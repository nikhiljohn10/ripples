FROM data-science:base

LABEL maintainer="Nikhil John <nikhiljohn1010@gmail.com>"

RUN conda install -c anaconda keras-gpu -y

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
