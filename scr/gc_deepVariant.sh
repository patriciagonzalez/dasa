#Deep variant gcloud 

#Create gcloud VM
gcloud compute instances create \
    deepvariantex-deepvariant-run \
    --project deepvariantex \
    --zone us-central-a \
    --scopes "cloud-platform" \
    --image-project ubuntu-os-cloud \
    --image-family ubuntu-1604-lts \
    --machine-type n1-standard-64 \
    --min-cpu-platform "Intel Skylake" \
    --boot-disk-size=300GB


#Install the Docker Community Edition (CE):

sudo apt-get -qq -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get -qq -y update
sudo apt-get -qq -y install docker-ce


#Set the environment variables 
BIN_VERSION="1.1.0"
BASE="/deepvariant-run"
INPUT_DIR="${BASE}/input"
REF="hg38.fa"
BAM="${BASE}/input/data/R1_R2_12878_S19_sorted.bam"
OUTPUT_DIR="${BASE}/output"
DATA_DIR="${INPUT_DIR}/data"
OUTPUT_VCF="hg38.12878.S19.output.vcf.gz"
OUTPUT_GVCF="hgr38.12878.S19.output.g.vcf.gz"


#Make directories
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${INPUT_DIR}"
mkdir -p "${DATA_DIR}"


#Get the DeepVariant image:
sudo docker pull gcr.io/deepvariant-docker/deepvariant:"${BIN_VERSION}"

#Start the DeepVariant 
sudo docker run \
    -v "${DATA_DIR}":"/input" \
    -v "${OUTPUT_DIR}:/output" \
    gcr.io/deepvariant-docker/deepvariant:"${BIN_VERSION}"  \
    /opt/deepvariant/bin/run_deepvariant \
    --model_type=WGS \
    --ref="/input/${REF}" \
    --reads="/input/${BAM}" \
    --output_vcf=/output/${OUTPUT_VCF} \
    --output_gvcf=/output/${OUTPUT_GVCF} \
    --regions chr20 \
    --num_shards=$(nproc) \
    --intermediate_results_dir /output/intermediate_results_dir


call_variants_output.tfrecord.gz
gvcf.tfrecord-SHARD_NUMBER-of-NUM_OF_SHARDS.gz
make_examples.tfrecord-SHARD_NUMBER-of-NUM_OF_SHARDS.gz


ls $OUTPUT_DIR


#source:https://cloud.google.com/life-sciences/docs/tutorials/deepvariant#console_1 
