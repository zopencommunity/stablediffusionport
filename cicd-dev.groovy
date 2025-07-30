node('linux')
{
  stage ('Poll') {
    checkout([
      $class: 'GitSCM',
      branches: [[name: '*/main']],
      doGenerateSubmoduleConfigurations: false,
      extensions: [],
      userRemoteConfigs: [[url: 'https://github.com/zopencommunity/stable_diffusionport.git']]])
  }
  stage('Build') {
    build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/zopencommunity/stable_diffusionport.git'), string(name: 'PORT_DESCRIPTION', value: 'Stable Diffusion is a text-to-image AI model that generates images from textual descriptions' ), string(name: 'BUILD_LINE', value: 'DEV') ]
  }
}
