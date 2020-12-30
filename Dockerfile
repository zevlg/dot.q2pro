# mkdir q2 && cp -Rp /path/to/baseq2 q2 && cp -Rp /path/to/action q2
# docker build -f ~/github/dot.q2pro/Dockerfile q2
# docker run -it -p 27910:27910/udp <image>

FROM ubuntu:latest
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils build-essential ca-certificates git zlib1g-dev

COPY . /q2

RUN git clone https://github.com/skullernet/q2pro.git
RUN git clone https://github.com/aq2-tng/aq2-tng
RUN git clone https://github.com/zevlg/dot.q2pro
RUN cd q2pro && make q2proded && cd ..
RUN cd aq2-tng/source && make && cd ../..
RUN cp q2pro/q2proded /q2
RUN cp aq2-tng/source/gamex86_64.so /q2/action
RUN cp dot.q2pro/aqtp.cfg /q2/action
RUN cp dot.q2pro/aq2ded.sh /q2/action

WORKDIR /q2
USER nobody
CMD ["./q2proded", "+game", "action", "+set", "ininame", "config/action.ini", "+set", "maplistname", "config/maplist.ini", "+set", "configlistname", "config/configlist.ini", "+exec", "aqtp.cfg", "+map", "rok"]
