FROM centos:7.4.1708
MAINTAINER liukuan <liukuan73@gmail.com>

#Dockerfile for systemd base image
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [/sys/fs/cgroup /run /tmp]

USER root
RUN mkdir /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
RUN yum install -y epel-release
RUN yum install -y python-pip
RUN pip install netaddr==0.7.19 jinja2==2.8 coverage==4.5.1 junit-xml==1.8 ansible==2.4.0
COPY ansible.cfg /etc/ansible/
CMD ["/usr/sbin/init"]
