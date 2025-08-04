#!/bin/sh

chgrp video /dev/nvidia-caps/* && chmod g+rw /dev/nvidia-caps/* && \
chgrp -R video /dev/dri/card0 && chmod g+rw /dev/dri/card0  && \
chgrp -R video /dev/nvidia* && chmod g+rw /dev/nvidia*