# JavaApp CI/CD(Jenkins) Pipeline Architecture
- This repo is maintained by [Devops with Mike](https://www.youtube.com/@DevOpsWithMike0/videos/)
- For interview preparation, use this platform [Wandaprep](http://www.wandaprep.com/)
- Visit my website for more inquiries and support [DevOpswithMike](https://devopswithmike.tech/).

![CompleteCICDProject!](https://lucid.app/publicSegments/view/a6ef3233-7dda-483a-a662-d8ec90395ba3/image.png)

## Pipeline Environment Configuration  

1) Create a GitHub Repository `wandaprep-java-cicd-Project` and push the code in this branch(main) to 
    your remote repository (your newly created repository).
    - Go to GitHub (github.com)
    - Login to your GitHub Account
    - Create a Repository called "wandaprep-java-cicd-Project"
    - Clone the Repository in the "Repository" directory/folder in your local
    - Download the code in in this repository "Main branch": https://github.com/devopsmike-01/JavaApp-CICD-Repo.git
    - Unzip the code/zipped file
    - Copy and Paste everything from the zipped file into the repository you cloned in your local
    - Add the code to git, commit and push it to your upstream branch "main or master"
    - Confirm that the code exist on GitHub

2) Jenkins/Maven/Ansible
    - Create an Amazon Linux 2023 VM instance and call it `jenkins-maven-ansible-server`
    - Instance type: t2.medium
    - Security Group (Open): 8080, 9100 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair
    - User data (Copy the following user data): https://github.com/Michaelgwei86/eagles-batch-devops-projects/blob/maven-nexus-sonarqube-jenkins-install/jenkins-install.sh 
    - Launch Instance

3) SonarQube
    - Create an Create an Ubuntu 22.04 VM instance and call it `SonarQube-server`
    - Instance type: t2.medium
    - Security Group (Open): 9000, 9100 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair
    - User data (Copy the following user data): https://github.com/Michaelgwei86/eagles-batch-devops-projects/blob/maven-nexus-sonarqube-jenkins-install/sonarqube-install.sh
    - Launch Instance

4) Nexus
    - Create an Amazon Linux 2023 VM instance and call it `Nexus-server`
    - Instance type: t2.medium
    - Security Group (Open): 8081, 9100 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair
    - User data (Copy the following user data): https://github.com/Michaelgwei86/eagles-batch-devops-projects/blob/maven-nexus-sonarqube-jenkins-install/nexus-install.sh
    - Launch Instance

5) EC2 (Dev/Stage/Prod)
    - Create 3 Amazon Linux 2023 VM instance and call them (Names: Dev-Env, Stage-Env and Prod-Env)
    - Instance type: t2.micro
    - Security Group (Open): 8080, 9100 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair

6) Prometheus
    - Create an Ubuntu 22.04 VM instance and call it `Prometheus-server`
    - Instance type: t2.micro
    - Security Group (Open): 9090 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair
    - Launch Instance

7) Grafana
    - Create an Ubuntu 22.04 VM instance and call it `Grafana-server`
    - Instance type: t2.micro
    - Security Group (Open): 3000 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair
    - Launch Instance

8) Slack 
    - Go to the bellow Workspace and create a Private Slack Channel and name it `yourfirstname-jenkins-cicd-pipeline-alerts`
    - Link: https://join.slack.com/t/devopswithmike/shared_invite/zt-1q6h1yw0j-d3Rt7Bu6rEkPHVBC5y82nw 

9) Configure Prometheus
    - Login/SSH to your Prometheus Server
    - Clone the following repository: https://github.com/devopsmike-01/JavaApp-CICD-Repo.git
    - Change directory to **installations**
    - Run: `./install-prometheus.sh`
    - Confirm the status shows "Active (running)"
    - Exit

10) Configure Grafana
    - Login/SSH to your Grafana Server
    - Clone the following repository: https://github.com/devopsmike-01/JavaApp-CICD-Repo.git
    - Change directory to **installations**
    - Run: `./install-grafana.sh`
    - Confirm the status shows "Active (running)"
    - Exit

11) Configure The "Node Exporter" accross the `Dev-server`, `Stage-server` and `Prod-server` instances including your "Pipeline Infra"
    - Login/SSH into the "Dev-Env", "Stage-Env" and "Prod-Env" VM instance
    - Perform the following operations on all of them
    - Install git by running: `sudo yum install git -y `
    - Clone the following repository: https://github.com/devopsmike-01/JavaApp-CICD-Repo.git
    - Change directory to **installations**
    - Run: `./install-node-exporter.sh`
    - Confirm the status shows "Active (running)"
    - Access the Node Exporters running on port "9100", open your browser and run the below
        - `Dev-EnvPublicIPaddress:9100 `  (Confirm this page is accessible)
        - `Stage-EnvPublicIPaddress:9100`   (Confirm this page is accessible)
        - `Prod-EnvPublicIPaddress:9100`   (Confirm this page is accessible)
    - Exit

12) Configure The **Node Exporter** on the `Jenkins-Maven-Ansible-server`, `Nexus-server` and `SonarQube-server` instances 
    - Login/SSH into the `Jenkins-Maven-Ansible-server`, `Nexus-server` and `SonarQube-server` VM instance
    - Perform the following operations on all of them
    - Install git by running: `sudo yum install git -y`    (The SonarQube server already has git)
    - Clone the following repository: https://github.com/awanmbandi/eagles-batch-devops-projects.git
    - Change directory to **installations**
    - Run: `./install-node-exporter.sh`
    - Make sure the status shows "Active (running)"
    - Access the Node Exporters running on port "9100", open your browser and run the below
        - `Jenkins-Maven-AnsiblePublicIPaddress:9100`   (Confirm the pages are accessible)
        - `NexusPublicIPaddress:9100`   
        - `SonarQubePublicIPaddress:9100`   
    - Exit

13) Update the Prometheus config file to contain the specific region in which Service discovery is running e.g `us-east-1`
    running the Node Exporter API. That'll include ("Dev", "Stage", "Prod", "Jenkins-Maven-Ansible", "Nexus" and "SonarQube")
    - SSH into the Prometheus instance either using your GitBash (Windows) or Terminal (macOS) or browser
    - Run the command: sudo vi /etc/prometheus/prometheus.yml
        - Navigate to "`ec2_sd_configs` for both the **job_name:node** and **job_name:jenkins** and update the `-region:us-east-1` to correspond to the region you are currently working in.
        - Save the Config File and Quit
    - Open a TAB on your choice browser
    - Copy the Prometheus PublicIP Addres and paste on the browser/tab with port 9100 e.g `PrometheusPublicIPAddres:9100`
        - Once you get to the Prometheus Dashboard Click on "Status" and Click on "Targets"
    - Confirm that Prometheus is able to reach everyone of your Nodes, do this by confirming the Status **UP** (green)
    - Done

14) Open a New Tab on your browser for Grafana also if you've not done so already. 
    - Copy your Grafana Instance Public IP and put on the browser with port **3000** e.g "GrafanaPublic:3000"
    - Once the UI Opens pass the following username and password
        - Username: admin
        - Password: admin
        - New Username: admin
        - New Password: admin
        - Save and Continue
    - Once you get into Grafana, follow the below steps to Import a Dashboard into Grafana to visualize your Infrastructure/App Metrics
        - Click on "Configuration/Settings" on your left
        - Click on "Data Sources"
        - Click on "Add Data Source"
        - Select Prometheus
        - Underneath HTTP `URL: http://PrometheusPublicOrPrivateIPaddress:9090`
        - Click on "SAVE and TEST"
    - Navigate to "Create" on your left (the `+` sign)
        - Click on "Import"
        - Copy the following link: https://grafana.com/grafana/dashboards/1860
        - Paste the above link where you have "Import Via Grafana.com"
        - Click on Load (The one right beside the link you just pasted)
        - Scrol down to "Prometheus" and select the "Data Source" you defined ealier which is "Prometheus"
        - CLICK on "Import"
    - Refresh your Grafana Dashbaord 
        - Click on the "Drop Down" for "Host" and select any of the "Instances(IP)"

15) Update Your Jenkins file with your Slack Channel Name
    - Go back to your local, open your "wandaprep-java-cicd-Project" repo/folder/directory on VSCODE
    - Open your **Jenkinsfile**
    - Update the slack channel name on line "97"
    - Change name from "wandaprep-cicd-pipeline-alerts" to yours
    - Add the changes to git, commit and push to GitHub
    - Confirm the changes reflects on GitHub

16) Copy your Jenkins Public IP Address and paste on the browser = ExternalIP:8080
    - Login to your Jenkins instance using your Shell (GitBash or your Mac Terminal)
    - Copy the Path from the Jenkins UI to get the Administrator Password
        - Run: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
        - Copy the password and login to Jenkins
    - Plugins: Choose Install Suggested Plugings 
    - Provide 
        - Username: admin
        - Password: admin
        - Name and Email can also be admin. You can use `admin` all through as we
    - Continue and Start using Jenkins

17) Once on the Jenkins Dashboard
    - Click on "Manage Jenkins"
    - Click on "Plugin Manager"
    - Click "Available"
    - Search and Install the following Plugings "Install Without Restart"
        - SonnarQube Scanner
        - Maven Integration
        - Pipeline Maven Integration
        - Maven Release Plug-In
        - Slack Notification
    - Install all plugings without restart 

18) Confirm and make test your installations/setups  

# Happy Learning
