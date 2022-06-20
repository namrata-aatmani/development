#FROM node:0.10.41
#MAINTAINER "basavarajvinay1702@gmail.com"
#SHELL ["/bin/bash","-apt-get install npm -y"]
#SHELL ["/bin/bash","-npm install -g express"]
#SHELL ["/bin/bash","-npm install -g express-generator"]
#SHELL ["/bin/bash","-express express-website"]
#SHELL ["/bin/bash","-git clone https://github.com/BasavarajK1/AatmaaniProject.git"]
#WORKDIR /AatmaaniProject/nodewebsite/express-website
#SHELL ["/bin/bash","-npm install"]
#SHELL ["/bin/bash","-npm install --save nodemailer"]
#ENTRYPOINT npm start
#EXPOSE 3000

FROM node:0.10.41
RUN apt-get update
#install git
RUN apt-get install git -y
RUN npm install -g express
RUN npm install -g express-generator
RUN git clone https://github.com/BasavarajK1/AatmaaniProject.git
WORKDIR /AatmaaniProject/nodewebsite/express-website
#install npm
RUN npm install
RUN npm install --save nodemailer
ENTRYPOINT npm start
EXPOSE 3000

