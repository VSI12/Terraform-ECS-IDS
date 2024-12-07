FROM public.ecr.aws/docker/library/python:3.12

#set the working dir
WORKDIR /usr/src/app

#copy the requirements
COPY requirements.txt .
#install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all the files to the container
COPY . .


#exposing the port
EXPOSE 8080

#run the app
CMD ["gunicorn","-b","0.0.0.0:8080", "app:app"]