## Usage
```
docker run -d -v /home/pi/kafka/data:/data -v /home/pi/kafka/log:/log -p 9092:9092 -p 2181:2181 -e ADVERTISED_HOST=192.168.1.158 --name kafka jiesu/kafka-arm
```

