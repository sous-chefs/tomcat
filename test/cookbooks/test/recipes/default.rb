apt_update 'update' if platform_family?('debian')

include_recipe 'test::docs_example'
include_recipe 'test::helloworld_example'
