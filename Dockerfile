# FROM ros:humble-ros-base-jammy

# SHELL ["/bin/bash", "-c"]

# # Install dependencies
# RUN apt-get update && \
#     apt-get install -y \
#         curl \
#         apt-transport-https \
#         lsb-release \
#         gnupg \
#         vim \
#         nano \
#         git \
#         git-core \
#         python3-colcon-common-extensions \
#         python3-rosdep

# # Create keyring directory
# RUN mkdir -p /etc/apt/keyrings

# # Download and install Librealsense key
# RUN curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | tee /etc/apt/keyrings/librealsense.pgp > /dev/null

# # Add the Librealsense repository to sources.list - explicitly using jammy
# RUN echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo jammy main" | tee /etc/apt/sources.list.d/librealsense.list

# # Update apt repositories
# RUN apt-get update

# # Install the necessary packages 
# RUN apt-get update && \
#     apt-get install -y \
#         librealsense2-utils \
#         librealsense2-dev \
#     || echo "Unable to install RealSense packages, continuing anyway"

# # Install ROS2 packages and dependencies
# RUN apt-get install -y \
#         ros-$ROS_DISTRO-realsense2-camera \
#         ros-$ROS_DISTRO-rviz2 \
#         ros-$ROS_DISTRO-tf2-tools \
#         ros-$ROS_DISTRO-rqt-tf-tree \
#         ros-$ROS_DISTRO-tf2-ros \
#         ros-$ROS_DISTRO-rclcpp \
#         ros-$ROS_DISTRO-rclcpp-components \
#         ros-$ROS_DISTRO-std-msgs \
#         ros-$ROS_DISTRO-std-srvs \
#         ros-$ROS_DISTRO-sensor-msgs \
#         ros-$ROS_DISTRO-cv-bridge \
#         ros-$ROS_DISTRO-image-transport \
#         ros-$ROS_DISTRO-message-filters \
#         ros-$ROS_DISTRO-diagnostic-updater \
#         ros-$ROS_DISTRO-builtin-interfaces \
#         ros-$ROS_DISTRO-vision-opencv \
#         libqt5gui5 \
#         libqt5core5a \
#         libqt5widgets5 \
#         libgl1-mesa-dev \
#         libxcb-xinerama0 \
#         libxcb-icccm4 \
#         libxcb-image0 \
#         libxcb-keysyms1 \
#         libxcb-render-util0 \
#         libxcb-xkb1 \
#         libxkbcommon-x11-0

# # Install ArUco packages for ROS2
# RUN apt-get install -y \
#         ros-$ROS_DISTRO-aruco-msgs || true

# # Source ROS2 environment in bashrc
# RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

# # Create a workspace for RealSense
# RUN mkdir -p /app/ros2_ws/src

# # Set the working directory
# WORKDIR /app/ros2_ws

# # Extract and store the package version for realsense2_camera if available
# RUN if [ -d "/opt/ros/$ROS_DISTRO/share/realsense2_camera" ]; then \
#     echo $(cat /opt/ros/$ROS_DISTRO/share/realsense2_camera/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt; \
#     fi



FROM ros:humble-ros-base-jammy
SHELL ["/bin/bash", "-c"]
# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        apt-transport-https \
        lsb-release \
        gnupg \
        vim \
        nano \
        git \
        git-core \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-pip

# Create keyring directory
RUN mkdir -p /etc/apt/keyrings

# Download and install Librealsense key
RUN curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | tee /etc/apt/keyrings/librealsense.pgp > /dev/null

# Add the Librealsense repository to sources.list - explicitly using jammy
RUN echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo jammy main" | tee /etc/apt/sources.list.d/librealsense.list

# Update apt repositories
RUN apt-get update

# Install the necessary packages 
RUN apt-get update && \
    apt-get install -y \
        librealsense2-utils \
        librealsense2-dev \
    || echo "Unable to install RealSense packages, continuing anyway"

# Install ROS2 packages and dependencies
RUN apt-get install -y \
        ros-$ROS_DISTRO-realsense2-camera \
        ros-$ROS_DISTRO-rviz2 \
        ros-$ROS_DISTRO-tf2-tools \
        ros-$ROS_DISTRO-rqt-tf-tree \
        ros-$ROS_DISTRO-tf2-ros \
        ros-$ROS_DISTRO-rclcpp \
        ros-$ROS_DISTRO-rclcpp-components \
        ros-$ROS_DISTRO-std-msgs \
        ros-$ROS_DISTRO-std-srvs \
        ros-$ROS_DISTRO-sensor-msgs \
        ros-$ROS_DISTRO-cv-bridge \
        ros-$ROS_DISTRO-image-transport \
        ros-$ROS_DISTRO-message-filters \
        ros-$ROS_DISTRO-diagnostic-updater \
        ros-$ROS_DISTRO-builtin-interfaces \
        ros-$ROS_DISTRO-vision-opencv \
        libqt5gui5 \
        libqt5core5a \
        libqt5widgets5 \
        libgl1-mesa-dev \
        libxcb-xinerama0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-render-util0 \
        libxcb-xkb1 \
        libxkbcommon-x11-0

# Install Python dependencies for ArUco
RUN pip3 install opencv-contrib-python transforms3d

# Install tf_transformations library
RUN cd /tmp && \
    git clone https://github.com/DLu/tf_transformations && \
    cd tf_transformations && \
    pip3 install -e .

# Source ROS2 environment in bashrc
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

# Create workspace directory
RUN mkdir -p /app/ros2_ws/src

# Set the working directory
WORKDIR /app/ros2_ws

# Extract and store the package version for realsense2_camera if available
RUN if [ -d "/opt/ros/$ROS_DISTRO/share/realsense2_camera" ]; then \
    echo $(cat /opt/ros/$ROS_DISTRO/share/realsense2_camera/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt; \
    fi