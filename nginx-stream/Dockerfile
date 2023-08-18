FROM debian
RUN apt -y update
RUN apt install -y build-essential libpcre3-dev zlib1g-dev libssl-dev git
RUN git clone https://github.com/nginx/nginx.git
WORKDIR /nginx
RUN ./auto/configure --with-stream --with-stream_ssl_preread_module
RUN make && make install
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

#docker run --restart=always -d --net=host -v ${PWD}/nginx.conf:/usr/local/nginx/conf/nginx.conf nginx-stream