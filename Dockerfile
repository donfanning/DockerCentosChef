FROM centos:centos6
MAINTAINER Don Fanning <don@00100100.net>

RUN rpm -Uvh http://fedora.mirror.nexicom.net/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN sed -i '/^\[centosplus\]$/,/^\[/ s/^enabled=0$/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo
RUN yum -y clean all
RUN yum -y update
RUN yum -y upgrade
RUN yum -y reinstall udev
RUN yum -y install tar which
RUN curl -L https://www.opscode.com/chef/install.sh | bash
RUN curl -L get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ruby"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN yum -y install git
RUN git clone https://github.com/opscode/chef-init.git
RUN /bin/bash -l -c "cd chef-init; gem build chef-init.gemspec; gem install chef-init-0.1.2.dev.gem"
ADD first-boot.json /etc/chef/first-boot.json
ADD client.rb /etc/chef/client.rb
ADD validation.pem /etc/chef/validation.pem
RUN source /etc/profile.d/rvm.sh
#RUN /bin/bash -l -c "chef-init --bootstrap"
RUN /bin/bash -l -c "chef-client"
