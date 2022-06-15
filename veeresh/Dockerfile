FROM node
RUN apt-get update
#install git
RUN apt-get install git -y
RUN npm install -g express
RUN npm install -g express-generator
RUN git clone https://github.com/nveeresh133/AatmaaniProject.git
WORKDIR /AatmaaniProject/nodewebsite/express-website
#install npm
RUN npm install
RUN npm install --save nodemailer
ENTRYPOINT npm start
EXPOSE 3000

