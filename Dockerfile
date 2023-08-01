#设置继承镜像
FROM ubuntu
RUN apt-get update
#安装ssh服务
RUN apt-get install -y openssh-server qemu-kvm *zenhei* xz-utils dbus-x11 curl gnome-system-monitor mate-system-monitor  git xfce4 xfce4-terminal tightvncserver wget
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh
#取消pam限制
RUN sed -ri 's/session required pam_loginuid.so/#session required pam_loginuid.so/g' /etc/pam.d/sshd
#复制配置文件到相应位置，并赋予脚本可执行权限
RUN echo 'root:KrOkFIyOZPv7Lr8Y' |chpasswd
RUN echo apt clean \
			&& rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp* \
			&& echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
ADD run.sh /run.sh
RUN chmod 755 /run.sh
RUN wget http://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN curl -LO https://proot.gitlab.io/proot/bin/proot
RUN chmod 755 proot
RUN mv proot /bin
RUN tar -xvf v1.2.0.tar.gz
RUN mkdir  $HOME/.vnc
RUN echo 'luo' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd
RUN echo 'whoami ' >>/luo.sh
RUN echo 'cd ' >>/luo.sh
RUN echo "su -l -c  'vncserver :2000 -geometry 1280x800' "  >>/luo.sh
RUN echo 'cd /noVNC-1.2.0' >>/luo.sh
RUN echo './utils/launch.sh  --vnc localhost:7900 --listen 8900 ' >>/luo.sh
RUN chmod 755 /luo.sh
#开放端口
EXPOSE 22 24444 8099 8888
#设置自启动命令
CMD ["/run.sh","/luo.sh"]
