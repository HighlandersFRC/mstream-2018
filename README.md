# 2018-Jevois-RPI-configuration
This repository contains Linux scripts, Jevois configuration files and documentation on how to configure a video streaming solution for First Robotics, FRC robotics competitions.

## Usage Instructions 
1. Automatic behavoir once installation and configuration are complete
   1. With PI powered off, connect 1-3 Jevois cameras to your PI 
   1. **NOTE: The Pi cannot reliably power more than one Jevois camera. 
   1. Boot up the PI and power the Jevois cameras.
   1. 1-3 connected Jevois cameras will begin streaming video on ports **5800**, **5801** and **5802**
   1. The cameras should receive power at about the same time as the pi. If the cameras are powered later, then manually run the **/home/pi/start.sh** on the PI after the cameras are connected.

1. Manually start and stop streaming
   1. /home/pi/start.sh
   1. /home/pi/stop.sh


## Compatibility
1. These instructions were verified with the following configurations:
   1. Raspberry PI Model 2B, Raspian OS Version: **8 (stretch)**, JeVois: **1.8.1**
   1. Raspberry PI Model 3B, Raspian OS Version: **8 (stretch)**, JeVois: **1.8.1**
   1. Raspberry PI Model 3B, (unknown Raspian), JeVois: **1.7.2**, 
   
   
## Configuration Instructions
1. Raspberry PI Configuration
   1. Install and build the mjpg-streamer package on the Raspberry PI
      1. [MJPG Instructions](https://github.com/cncjs/cncjs/wiki/Setup-Guide:-Raspberry-Pi-%7C-MJPEG-Streamer-Install-&-Setup-&-FFMpeg-Recording)   
      1. To enable future customization of individual camera streams the a separate copy of the www directory is created for 3 streams.
         1. **sudo cp /usr/local/share/mjpg-streamer/www /home/pi/www_0**
         1. **sudo cp /usr/local/share/mjpg-streamer/www /home/pi/www_1**
         1. **sudo cp /usr/local/share/mjpg-streamer/www /home/pi/www_2**
         1. **sudo chown -R pi:pi /home/pi/www_0**
         1. **sudo chown -R pi:pi /home/pi/www_1**
         1. **sudo chown -R pi:pi /home/pi/www_2**
         
   1. Configure static IP on the PI for
      1. Configure a static IP for the PI which will work with the RoboRio (**10.XX.YY.11** where your team number is **xx.yy**)
      1. The *.11 IP address was chosen to comply with [FRC Standards](https://wpilib.screenstepslive.com/s/4485/m/24193/l/319135-ip-networking-at-the-event)
      1. Edit file: **/etc/dhcpd.conf**
      1. A sample file Modify the IP and then copy it to **/etc/dhcpd.conf** on the PI)
      
   1. Configure Crontab to start camera streaming on reboot
      1. Default configuration is to start up to 3 cameras.
      1. The default configuration also shuts down the WiFi which is good practice for FRC competitions.
      1. See file: **/var/spool/cron/crontabs/pi**
      1. The main configuration line to be added is:
         **@reboot nohup /home/pi/start.sh > /home/pi/start.log 2>&1 &**

   1. Scripts from this repo used to manage streaming should be copied to **/home/pi/**
      1. **/home/pi/mjpg-streamer.sh** helper script to invoke mjpg-streamer binary 
      1. **/home/pi/start.sh** Simple wrapper to invoke mjpg-streamer for multiple cameras.
      1. **/home/pi/stop.sh** Optional wrapper to kill all running instances of mjpg-streamer.
      1. **/home/pi/status.sh** Optional wrapper to report status of any running instances of mjpg-streamer.
      1. **/home/pi/down.sh** Optional wrapper to shutdown PI.
      
1. Jevois configuration file
   1. Enable Multicam mode
      1. Enable multiple cameras by reducing Jevois USB allocation by creating file **multicam** in the boot partition. 
      1. [Jevois documentation on multicam option](http://jevois.org/doc/Multicam.html)   
   1. Default Video Mode
      1. Edit the **config/videomappings.cfg** file to set the default video mode by placing an asterisk at the end of the following line
         - MJPG 320 240 15.0 YUYV 320 240 15.0 JeVois Convert *
      1. Remember to remove the asterisk from the setting it was previously on as there can only be one default video mode.
      1. The config file for Jevois 1.8.1 with the required modifications is located at **config/1_8_1/videomappings.cfg**
   1. **config/initscript,cfg**
      1. Uncomment the following lines in the **config/initscript.cfg** file on your jevois to enable serial messages on the hard port:
         - **setpar serlog Hard**
         - **setpar serout Hard**
      1. The config file for Jevois **1.8.1** with the required modifications is located at **config/1_8_1/videomappings.cfg**
   1. FRC information on Jevois and image processing
      - [Chield Delphi: Using JeVois in FRC](https://www.chiefdelphi.com/media/papers/3405?)
      - [FIRST Robotics vision module](http://jevois.org/tutorials/UserFirstVision.html)
      - [JeVois Design Guide by teams **1836** and **3991**](https://docs.google.com/document/d/1duM0ncfjExYepVAZtkhaMqqkwEJHyFDX487YP9TIzzA/edit)
      - [WPILIB on vision processing](https://wpilib.screenstepslive.com/s/currentCS/m/vision)
      - [JeVois camear mount on Thingiverse](https://www.thingiverse.com/thing:2692328)

## Basic Jevois How-To:
1. Getting started with Jevois
   1. [Hardware](https://www.jevoisinc.com/pages/hardware)
   1. [Software](https://www.jevoisinc.com/pages/software)
   1. [Main Documentation](http://jevois.org/doc/)
   1. [Download SD images](http://jevois.org/start/software.html)
   1. [Jevois documentation on multicam option](http://jevois.org/doc/Multicam.html)   
1. Sserial port command line:
   1. **usbsd** - to mount the sd card from the running camera on windows.
1. Config files:
   1. **config/videomappings.cfg** Edit to set default video mode
   1. **config/initscript.cfg** Edit to set default serial port usage

## Basic Raspberry PI How-To:
1. [Check Hardware version](https://elinux.org/RPi_HardwareHistory)
1. [Check Raspian OS version](https://www.meccanismocomplesso.org/en/how-to-raspberry-checking-raspbian-version-update-upgrade/)
1. [Configure static IP on the PI for wired, eth0](https://www.raspberrypi.org/forums/viewtopic.php?t=191140)
1. List USB devices
   1. **lsusb** 
   1. **lsusb -s 001:006 -v | egrep "Width|Height"**
1. Check video devices:
   1. **/usr/bin/v4l2-ctl --list-formats-ext**  # To show Supported Video Formats
   

## MJPG-STREAMER Notes
1. Install the mjpg-streamer source from github
   1. [MJPG Instructions](https://github.com/cncjs/cncjs/wiki/Setup-Guide:-Raspberry-Pi-%7C-MJPEG-Streamer-Install-&-Setup-&-FFMpeg-Recording)   
   1. [Alternate instructions for configuring mjpg streamer on PI](https://www.collaborizm.com/thread/SyFenrp6l)
1. Other resolution options (must coordinate with Jevois)
   - 160x120 176x144 320x240 352x288 424x240 432x240 640x360 640x480 800x448 800x600 960x544 1280x720 1920x1080 (QVGA, VGA, SVGA, WXGA)   
1. Other input options
   - INPUT_OPTIONS="-r ${RESOLUTION} -d ${VIDEO_DEV} -f ${FRAME_RATE} -q ${QUALITY} -pl 60hz"
   - INPUT_OPTIONS="-r ${RESOLUTION} -d ${VIDEO_DEV} -q ${QUALITY} -pl 60hz"
   - Limit Framerate with  "--every_frame ", ( mjpg_streamer --input "input_uvc.so --help" )

   
