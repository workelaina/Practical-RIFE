sudo mkdir -p /mnt/v1
sudo mount /dev/vdc /mnt/v1

mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
conda init --all

conda create -y -n py311 python=3.11
conda activate py311

scp -r ./Practical-RIFE ubuntu@62.169.159.54:/mnt/v1/

cd /mnt/v1
git clone https://github.com/workelaina/Practical-RIFE.git
cd Practical-RIFE

conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

python3 inference_video.py --multi=2 --video="demo/4k.mp4" --png
python3 inference_video.py --multi=2 --img="demo/imgs" --png
ffmpeg -i "imgs/%07d.png" -c:v libx264 -q:v 0 x2.h264
ffmpeg -i "imgs2/%07d.png" -c:v libx264 -q:v 0 x4.h264
ffmpeg -framerate 60 -i "imgs/%07d.png" -c:v libx264 -q:v 0 -r 60 x2_24s.mp4
ffmpeg -framerate 120 -i "imgs/%07d.png" -c:v libx264 -q:v 0 -r 120 x2_12s.mp4
ffmpeg -framerate 120 -i "imgs2/%07d.png" -c:v libx264 -q:v 0 -r 120 x4_24s.mp4
ffmpeg -framerate 240 -i "imgs2/%07d.png" -c:v libx264 -q:v 0 -r 240 x4_12s.mp4
