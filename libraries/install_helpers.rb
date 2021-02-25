module TomcatCookbook
  module InstallHelpers
    # break apart the version string to find the major version
    def major_version(version)
      @major_version ||= version.split('.')[0]
    end

    def default_tomcat_install_path(instance_name, version)
      "/opt/tomcat_#{instance_name}_#{version.tr('.', '_')}/"
    end

    def default_tomcat_symlink_path(instance_name)
      "/opt/tomcat_#{instance_name}"
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
      when -> (v) { Gem::Requirement.new('>= 9.0.10').satisfied_by?(v) }
        'sha512'
      else
        'md5'
      end
    end

    # Get the archive name
    def tomcat_archive_name(version)
      "apache-tomcat-#{version}.tar.gz"
    end

    # fetch the md5 checksum from the mirrors
    # we have to do this since the md5 chef expects isn't hosted
    def fetch_tomcat_checksum(checksum_uri, validate_ssl)
      uri = URI(checksum_uri)

      case uri.scheme
      when 'file'
        checksum_content = IO.read(uri.path)
      when 'http', 'https'
        request = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == 'https'
          request.use_ssl = true
          request.verify_mode = OpenSSL::SSL::VERIFY_NONE unless validate_ssl
        end

        response = request.get(uri)

        if response.code != '200'
          Chef::Log.fatal("Fetching the Tomcat tarball checksum at #{uri} resulted in an error #{response.code}")
          raise
        end

        checksum_content = response.body
      end

      checksum_content.split(' ')[0]
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
