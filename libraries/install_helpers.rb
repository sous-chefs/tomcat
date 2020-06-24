module TomcatCookbook
  module InstallHelpers
    # break apart the version string to find the major version
    def major_version(version)
      @major_version ||= version.split('.')[0]
    end

    def default_tomcat_install_path(instance_name, version)
      if platform?('windows')
        "C:/tomcat_#{instance_name}_#{version.tr('.', '_')}/"
      else
        "/opt/tomcat_#{instance_name}_#{version.tr('.', '_')}/"
      end
    end

    def default_tomcat_symlink_path(instance_name)
      if platform?('windows')
        "C:/tomcat_#{instance_name}"
      else
        "/opt/tomcat_#{instance_name}"
      end
    end

    def default_tomcat_archive_uri(base_uri, version, version_archive)
      URI.join(base_uri, "tomcat-#{major_version(version)}/v#{version}/bin/#{version_archive}").to_s
    end

    # returns the URI of the apache.org generated checksum based on either
    # an absolute path to the tarball or the tarball based path.
    def default_tomcat_checksum_uri(base_uri, version, version_archive)
      URI.join(base_uri, "tomcat-#{major_version(version)}/v#{version}/bin/#{version_archive}.#{version_checksum_algorithm(version)}").to_s
    end

    # Apache started using sha512 (replacing md5) in these versions and now
    # only publishes sha512 checksums
    def version_checksum_algorithm(version)
      case Gem::Version.new(version)
      when -> (v) { Gem::Requirement.new('~> 7.0.84').satisfied_by?(v) }
        'sha512'
      when -> (v) { Gem::Requirement.new('~> 8.0.48').satisfied_by?(v) }
        'sha512'
      when -> (v) { Gem::Requirement.new('~> 8.5.24').satisfied_by?(v) }
        'sha512'
      when -> (v) { Gem::Requirement.new('~> 9.0.10').satisfied_by?(v) }
        'sha512'
      else
        'md5'
      end
    end

    # Get the archive name
    def tomcat_archive_name(version)
      if platform?('windows')
        case node['kernel']['machine']
        when 'i386'
          windows_architecture = 'x86'
        when 'x86_64'
          windows_architecture = 'x64'
        end

        "apache-tomcat-#{version}-windows-#{windows_architecture}.zip"
      else
        "apache-tomcat-#{version}.tar.gz"
      end
    end

    # build the extraction command based on the passed properties
    def tomcat_extraction_command(version, install_path, archive_path, exclude_examples, exclude_docs, exclude_manager, exclude_hostmanager)
      if platform?('windows')
        # Powershell's built-in `Expand-Archive` doesn't allow excluding directories like tar
        # Also, the Windows archive has a nested `apache-tomcat-<version>` folder inside of the zip
        cmd = <<-EOH
          # Inputs
          $destination = '#{install_path}'
          $version = '#{version}'

          $archivePath = '#{archive_path}'

          $excludeExamples = $#{exclude_examples}
          $excludeDocs = $#{exclude_docs}
          $excludeManager = $#{exclude_manager}
          $excludeHostManager = $#{exclude_hostmanager}

          # Core Script
          Add-Type -AssemblyName System.IO.Compression.FileSystem

          $excludedRegexPaths = New-Object System.Collections.Generic.List[String]

          # Exclude the empty top level entry
          $excludedRegexPaths.Add("apache-tomcat-$version/$")

          # Exclude the temp file in the temp dir
          $excludedRegexPaths.Add("apache-tomcat-$version/temp/safeToDelete.tmp")

          if($excludeExamples){
              $excludedRegexPaths.Add('.*webapps\/examples.*')
              $excludedRegexPaths.Add('.*webapps\/ROOT.*')
          }

          if($excludeDocs){
              $excludedRegexPaths.Add('.*webapps\/docs.*')
          }

          if($excludeManager){
              $excludedRegexPaths.Add('.*webapps\/manager.*')
          }

          if($excludeHostManager){
              $excludedRegexPaths.Add('.*webapps\/host-manager.*')
          }

          # Take the excluded paths and build one big regex for it
          $regexPattern = $($excludedRegexPaths -join '|')

          $archive = [System.IO.Compression.ZipFile]::OpenRead($archivePath)

          foreach($entry in $archive.entries | Where-Object {$_.FullName -NotMatch $regexPattern}){
            # Build the destination file path; stripping out the apache-tomcat-version/ that exists on the entries
            $destinationPath = Join-Path -Path $destination -ChildPath $entry.FullName.Replace("apache-tomcat-$version/",'')

            # If the path ends with a slash, then create the directory, otherwise extract the zip entry
            if($entry.FullName.EndsWith('/')){
              New-Item -Path $destinationPath -ItemType Directory | Out-Null
            }else{
              [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destinationPath)
            }
          }

          $archive.Dispose()
        EOH
      else
        cmd = "tar -xzf #{archive_path} -C #{install_path} --strip-components=1"
        cmd << " --exclude='*webapps/examples*'" if exclude_examples
        cmd << " --exclude='*webapps/ROOT*'" if exclude_examples
        cmd << " --exclude='*webapps/docs*'" if exclude_docs
        cmd << " --exclude='*webapps/manager*'" if exclude_manager
        cmd << " --exclude='*webapps/host-manager*'" if exclude_hostmanager
      end

      cmd
    end

    # fetch the md5 checksum from the mirrors
    # we have to do this since the md5 chef expects isn't hosted
    def fetch_tomcat_checksum(checksum_uri, validate_ssl)
      uri = URI(checksum_uri)
      request = Net::HTTP.new(uri.host, uri.port)
      if uri.to_s.start_with?('https')
        request.use_ssl = true
        request.verify_mode = OpenSSL::SSL::VERIFY_NONE unless validate_ssl
      end
      response = request.get(uri)
      if response.code != '200'
        Chef::Log.fatal("Fetching the Tomcat tarball checksum at #{uri} resulted in an error #{response.code}")
        raise
      end
      response.body.split(' ')[0]
    rescue => e
      Chef::Log.fatal("Could not fetch the checksum due to an error: #{e}")
      raise
    end

    # validate the mirror checksum against the on disk checksum
    # return true if they match. Append .bad to the cached copy to prevent using it next time
    def validate_tomcat_checksum(file_to_check, version, checksum_uri, validate_ssl)
      desired = fetch_tomcat_checksum(checksum_uri, validate_ssl)
      klass = Object.const_get("Digest::#{version_checksum_algorithm(version).upcase}")
      actual = klass.hexdigest(::File.read(file_to_check, mode: 'rb'))

      if desired == actual
        true
      else
        Chef::Log.fatal("The checksum of the tomcat tarball on disk (#{actual}) does not match the checksum provided from the mirror (#{desired}). Renaming to #{::File.basename(file_to_check)}.bad")
        ::File.rename(file_to_check, "#{file_to_check}.bad")
        raise
      end
    end
  end
end
