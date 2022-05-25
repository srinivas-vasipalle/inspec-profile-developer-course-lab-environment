control 'nginx-version' do
    title 'Nginx version need to meet the standards'
    desc 'Nginx version need to be 1.10.3 or later'
    impact 1.0

    describe nginx do
        its('version') {should cmp >= input('nginx_version')}
    end
end

control 'nginx-modules' do
    title 'Nginx modules'
    desc 'The required Nginx modules must be installed'
    impact 1.0

    nginx_mod_var =  input('nginx_modules')

    describe nginx do
       nginx_mod_var.each do |current_module|
            its('modules') {should include current_module}
        end
    end
#    describe nginx do
#        its('modules') {should include 'http_ssl'}
#        its('modules') {should include 'stream_ssl'}
#        its('modules') {should include 'mail_ssl'}
#    end
end

control 'nginx-conf' do
    title 'Nginx Config file access'
    desc 'Nginx config file must be accessible to root only'
    impact 1.0

    describe file(input('conf_path')) do
            it {should be_owned_by input('root_users')}
            it {should be_grouped_into input('root_users')}
            it {should_not be_readable.by(input('other_users'))}
            it {should_not be_writable.by(input('other_users'))}
            it {should_not be_executable.by(input('other_users'))}
    end

    # describe file('/etc/nginx/nginx.conf') do
    #     it {should be_owned_by 'root'}
    #     it {should be_grouped_into 'root'}
    #     it {should_not be_readable.by('others')}
    #     it {should_not be_writable.by('others')}
    #     it {should_not be_executable.by('others')}
    # end
end