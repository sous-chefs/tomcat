# frozen_string_literal: true

name 'tomcat'

run_list 'test::default'

cookbook 'tomcat', path: '.'
cookbook 'test', path: 'test/cookbooks/test'
