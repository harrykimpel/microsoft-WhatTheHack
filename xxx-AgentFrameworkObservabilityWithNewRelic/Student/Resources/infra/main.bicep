param accounts_foundry_gameday_name string = 'foundry-gameday'
param monitors_NewRelicResource_GameDay_name string = 'NewRelicResource-GameDay'
param resources_AzureNativeNewRelic_externalid string = '/subscriptions/0d71791f-11d8-4b5f-b2af-d0846a507cd3/resourceGroups/newrelic-gameday/providers/Microsoft.SaaS/resources/AzureNativeNewRelic'

resource accounts_foundry_gameday_name_resource 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: accounts_foundry_gameday_name
  location: 'eastus'
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    apiProperties: {}
    customSubDomainName: accounts_foundry_gameday_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    allowProjectManagement: true
    defaultProject: 'project-gameday'
    associatedProjects: [
      'project-gameday'
    ]
    publicNetworkAccess: 'Enabled'
  }
}

resource monitors_NewRelicResource_GameDay_name_resource 'NewRelic.Observability/monitors@2025-05-01-preview' = {
  name: monitors_NewRelicResource_GameDay_name
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    orgCreationSource: 'LIFTR'
    accountCreationSource: 'LIFTR'
    newRelicAccountProperties: {
      accountInfo: {
        accountId: '7585826'
      }
      organizationInfo: {
        organizationId: '96cecd0c-9137-4a5c-a7b9-5bda3d1a153f'
      }
    }
    userInfo: {
      firstName: 'Harry'
      lastName: 'Kimpel'
      emailAddress: 'harry@kimpel.com'
      phoneNumber: '+49 8841-6726777'
    }
    planData: {
      usageType: 'PAYG'
      billingCycle: 'MONTHLY'
      planDetails: 'newrelic-pay-as-you-go-free-live@TIDn7ja87drquhy@PUBIDnewrelicinc1635200720692.newrelic_liftr_payg_2025'
      effectiveDate: '2026-01-13T06:47:27.061Z'
    }
    saaSData: {
      saaSResourceId: resources_AzureNativeNewRelic_externalid
    }
  }
}

resource accounts_foundry_gameday_name_Default 'Microsoft.CognitiveServices/accounts/defenderForAISettings@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

// resource accounts_foundry_gameday_name_gpt_4_1_nano 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'gpt-4.1-nano'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-4.1-nano'
//       version: '2025-04-14'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_gpt_4o_mini 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'gpt-4o-mini'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-4o-mini'
//       version: '2024-07-18'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

resource accounts_foundry_gameday_name_gpt_5_mini 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: 'gpt-5-mini'
  sku: {
    name: 'GlobalStandard'
    capacity: 100
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-5-mini'
      version: '2025-08-07'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 100
    raiPolicyName: 'Microsoft.DefaultV2'
  }
}

// resource accounts_foundry_gameday_name_gpt_5_nano 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'gpt-5-nano'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-5-nano'
//       version: '2025-08-07'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_o4_mini 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'o4-mini'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'o4-mini'
//       version: '2025-04-16'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_Phi_4_mini_reasoning 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'Phi-4-mini-reasoning'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 1
//   }
//   properties: {
//     model: {
//       format: 'Microsoft'
//       name: 'Phi-4-mini-reasoning'
//       version: '1'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 1
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

resource accounts_foundry_gameday_name_project_gameday 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: 'project-gameday'
  location: 'eastus'
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'Default project created with the resource'
    displayName: 'project-gameday'
  }
}

resource accounts_foundry_gameday_name_Microsoft_Default 'Microsoft.CognitiveServices/accounts/raiPolicies@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: 'Microsoft.Default'
  properties: {
    mode: 'Blocking'
    contentFilters: [
      {
        name: 'Hate'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Hate'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Sexual'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Sexual'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Violence'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Violence'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Selfharm'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Selfharm'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
    ]
  }
}

resource accounts_foundry_gameday_name_Microsoft_DefaultV2 'Microsoft.CognitiveServices/accounts/raiPolicies@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: 'Microsoft.DefaultV2'
  properties: {
    mode: 'Blocking'
    contentFilters: [
      {
        name: 'Hate'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Hate'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Sexual'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Sexual'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Violence'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Violence'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Selfharm'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Selfharm'
        severityThreshold: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Jailbreak'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        name: 'Protected Material Text'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        name: 'Protected Material Code'
        blocking: false
        enabled: true
        source: 'Completion'
      }
    ]
  }
}

resource monitors_NewRelicResource_GameDay_name_default 'NewRelic.Observability/monitors/monitoredSubscriptions@2025-05-01-preview' = {
  parent: monitors_NewRelicResource_GameDay_name_resource
  name: 'default'
  properties: {
    patchOperation: 'AddBegin'
    monitoredSubscriptionList: []
  }
}

resource NewRelic_Observability_monitors_tagRules_monitors_NewRelicResource_GameDay_name_default 'NewRelic.Observability/monitors/tagRules@2025-05-01-preview' = {
  parent: monitors_NewRelicResource_GameDay_name_resource
  name: 'default'
  properties: {
    logRules: {
      sendAadLogs: 'Disabled'
      sendSubscriptionLogs: 'Disabled'
      sendActivityLogs: 'Enabled'
      filteringTags: []
    }
    metricRules: {
      sendMetrics: 'Enabled'
      filteringTags: []
    }
  }
}
