var suffix = uniqueString('${subscription().subscriptionId}-${resourceGroup().name}')
param monitors_NewRelicResource_GameDay_name string = 'NewRelicResource-GameDay'

var location = resourceGroup().location

module openai 'modules/foundry.bicep' = {
  name: 'foundryDeployment'
  params: {
    location: location
    name: 'foundry-gameday-${suffix}'
  }
}

module newrelic 'modules/newrelic.bicep' = {
  name: 'newRelicDeployment'
  params: {
    location: location
    name: '${monitors_NewRelicResource_GameDay_name}-${suffix}'
  }
}
