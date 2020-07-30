# Build all images, tag each one, push to Docker hub
docker build -t zjayers/multi-client:latest -t zjayers/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t zjayers/multi-server:latest -t zjayers/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t zjayers/multi-worker:latest -t zjayers/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

docker push zjayers/multi-client:latest
docker push zjayers/multi-client:$GIT_SHA
docker push zjayers/multi-server:latest
docker push zjayers/multi-server:$GIT_SHA
docker push zjayers/multi-worker:latest
docker push zjayers/multi-worker:$GIT_SHA

# Apply all configs from the 'k8s' folder
kubectl apply -f k8s

# Set Google Cloud to use latest version of images
kubectl set image deployments/client-deployment client=zjayers/multi-client:$GIT_SHA
kubectl set image deployments/server-deployment server=zjayers/multi-server:$GIT_SHA
kubectl set image deployments/worker-deployment worker=zjayers/multi-worker:$GIT_SHA
