name 'test'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
version '1.0.0'

depends 'tomcat'

# final version to suppose default recipe
depends 'java', '<= 6.0.0'
