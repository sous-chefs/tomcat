module TomcatCookbook
  module ServiceHelpers
    # the install path of this instance of tomcat
    # make sure it doesn't end in / as well as that causes issues in init scripts
    def derived_install_path
      new_resource.install_path ? new_resource.install_path.chomp('/') : "/opt/tomcat_#{new_resource.instance_name}"
    end

    # make sure catalina base is in the env_var has no matter what
    def envs_with_catalina_base
      return new_resource.env_vars if new_resource.env_vars.any? { |env_hash| env_hash.key?('CATALINA_BASE') }

      env_vars = new_resource.env_vars.dup
      env_vars.unshift('CATALINA_BASE' => derived_install_path)
      env_vars
    end
  end
end
