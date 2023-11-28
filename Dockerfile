FROM python:3.7-alpine

ENV USER root

ENV PATH /root/.local/bin/:$PATH

RUN mkdir /python-sdk

WORKDIR /python-sdk

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache gcc g++ python3 python3-dev py3-pip  bash linux-headers libffi-dev  curl wget perl make

COPY requirements.txt /requirements.txt


RUN pip3 install -r /requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir

COPY . /python-sdk

RUN bash init_env.sh -i && \
    cp -ar /python-sdk/sdk/* bin/ && \
    ln -s /root/.local/bin/register-python-argcomplete /bin/register-python-argcomplete && \
    echo "eval \"\$(register-python-argcomplete ./console.py)\"" >> ~/.bashrc

EXPOSE 20200 30300 8545

CMD ["bash"]
