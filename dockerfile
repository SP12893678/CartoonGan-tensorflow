FROM alpine/git:latest AS keras-contrib-builder
WORKDIR /keras-contrib

RUN git clone https://github.com/SP12893678/keras-contrib.git

FROM tensorflow/tensorflow:latest-gpu-py3
COPY --from=keras-contrib-builder /keras-contrib/keras-contrib /keras-contrib
RUN cd /keras-contrib && python convert_to_tf_keras.py && USE_TF_KERAS=1 python setup.py install

RUN pip install imageio
RUN pip install tqdm

ENTRYPOINT ["tail","-f","/dev/null"]
