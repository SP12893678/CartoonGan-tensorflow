FROM alpine/git:latest AS builder
WORKDIR /keras-contrib
RUN git clone https://github.com/SP12893678/keras-contrib.git .

WORKDIR /project
RUN git clone https://github.com/SP12893678/CartoonGan-tensorflow.git .


FROM tensorflow/tensorflow:latest-gpu-py3

COPY --from=builder /keras-contrib /keras-contrib
RUN cd /keras-contrib && python convert_to_tf_keras.py && USE_TF_KERAS=1 python setup.py install

RUN pip install imageio
RUN pip install tqdm

COPY --from=builder /project /project
WORKDIR /project
ENTRYPOINT ["tensorboard", "--logdir", "runs", "--port=6007", "--bind_all"]
EXPOSE 6007
# ENTRYPOINT ["tail","-f","/dev/null"]
