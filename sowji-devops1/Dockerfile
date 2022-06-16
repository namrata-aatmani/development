FROM node
MAINTAINER Aatmaniproject
# install npm stall generator
RUN apt-get update
RUN npm install -g express
RUN npm install -g express-generator
# install git and clone
RUN apt-get update
RUN apt-get install git -y
RUN git clone https://github.com/VV-MANOJ/AatmaaniProject
#go to project directory
WORKDIR /AatmaniProject/nodewebsite/express-website
#RUN npm install
RUN npm install --save nodemailer
ENTRYPOINT npm start
EXPOSE 3000
