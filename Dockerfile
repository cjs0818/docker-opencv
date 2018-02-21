#FROM 	ubuntu:16.04
FROM 	nvidia/cuda

# generate /root/work directory
WORKDIR /root/work

# copy .bashrc from host to target /root directory
ADD .bashrc /root

# OpenCV version
ENV OPENCV_VERSION="3.4.0"


RUN 	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends python python-dev python-pip build-essential cmake git pkg-config libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libatlas-base-dev gfortran libavresample-dev libgphoto2-dev libgstreamer-plugins-base1.0-dev libdc1394-22-dev  vim && \
	pip install numpy && \
	cd /opt && \
	git clone https://github.com/opencv/opencv_contrib.git && \
	cd opencv_contrib && \
	git checkout ${OPENCV_VERSION} && \	
	cd /opt && \
	git clone https://github.com/opencv/opencv.git && \
	cd opencv && \
	git checkout ${OPENCV_VERSION} && \
	mkdir build && \
	cd build && \
	cmake 	-D CMAKE_BUILD_TYPE=RELEASE \
		-D BUILD_NEW_PYTHON_SUPPORT=ON \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D INSTALL_C_EXAMPLES=OFF \
		-D INSTALL_PYTHON_EXAMPLES=OFF \
		-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
		-D PYTHON_EXECUTABLE=/usr/bin/python2.7 \
		-D BUILD_EXAMPLES=OFF /opt/opencv && \
	make -j $(nproc) && \
	make install && \
	ldconfig && \
	apt-get purge -y git && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && \
	rm -rf /opt/opencv*

CMD /bin/bash
