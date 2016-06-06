source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt'
  cookbook 'zypper'
  cookbook 'yum'
  cookbook 'java', '>= 1.36'
end

cookbook 'test', path: 'test/cookbooks/test'
