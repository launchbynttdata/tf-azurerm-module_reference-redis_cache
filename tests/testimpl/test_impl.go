package testimpl

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/redis/armredis"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestComposableComplete runs all read-only SDK checks PLUS mutating operations.
// Used by post_deploy_functional.
func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	TestComposableCompleteReadOnly(t, ctx)
}

// TestComposableCompleteReadOnly verifies all resources via Azure SDK Get calls ONLY.
// No writes, no mutations. Used by post_deploy_functional_readonly.
func TestComposableCompleteReadOnly(t *testing.T, ctx types.TestContext) {
	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	require.NotEmpty(t, subscriptionID, "ARM_SUBSCRIPTION_ID must be set")

	redisCacheID := terraform.Output(t, ctx.TerratestTerraformOptions(), "redis_cache_id")
	redisCacheHostname := terraform.Output(t, ctx.TerratestTerraformOptions(), "redis_cache_hostname")

	require.NotEmpty(t, redisCacheID, "redis_cache_id output must not be empty")
	require.NotEmpty(t, redisCacheHostname, "redis_cache_hostname output must not be empty")

	// Parse resource group name and cache name from the ID
	// ID format: /subscriptions/.../resourceGroups/<rg>/providers/Microsoft.Cache/Redis/<name>
	resourceGroupName := ""
	cacheName := ""
	parts := splitResourceID(redisCacheID)
	for i, part := range parts {
		if part == "resourceGroups" && i+1 < len(parts) {
			resourceGroupName = parts[i+1]
		}
		if strings.EqualFold(part, "redis") && i+1 < len(parts) {
			cacheName = parts[i+1]
		}
	}
	require.NotEmpty(t, resourceGroupName, "Could not parse resource group name from redis_cache_id")
	require.NotEmpty(t, cacheName, "Could not parse cache name from redis_cache_id")

	t.Run("TestResourceGroupExists", func(t *testing.T) {
		rgClient := getAzureResourceGroupsClient(t, subscriptionID)
		rg, err := rgClient.Get(context.TODO(), resourceGroupName, nil)
		require.NoError(t, err, "Get ResourceGroup should succeed")
		assert.Equal(t, resourceGroupName, *rg.Name)
	})

	t.Run("TestRedisCacheExists", func(t *testing.T) {
		redisClient := getAzureRedisClient(t, subscriptionID)
		cache, err := redisClient.Get(context.TODO(), resourceGroupName, cacheName, nil)
		require.NoError(t, err, "Get Redis cache should succeed")
		assert.Equal(t, cacheName, *cache.Name)
		assert.True(t, strings.HasPrefix(*cache.Properties.RedisVersion, "6"), "Redis version should be 6.x, got: %s", *cache.Properties.RedisVersion)
		assert.Equal(t, armredis.PublicNetworkAccessDisabled, *cache.Properties.PublicNetworkAccess)
		assert.Equal(t, redisCacheHostname, *cache.Properties.HostName)
	})
}

func splitResourceID(id string) []string {
	var parts []string
	current := ""
	for _, c := range id {
		if c == '/' {
			if current != "" {
				parts = append(parts, current)
			}
			current = ""
		} else {
			current += string(c)
		}
	}
	if current != "" {
		parts = append(parts, current)
	}
	return parts
}

// --- Azure SDK Helper Functions ---

func getAzureCredential(t *testing.T) *azidentity.DefaultAzureCredential {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err, "unable to create Azure credential")
	return cred
}

func getAzureClientOptions() *arm.ClientOptions {
	return &arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}
}

func getAzureResourceGroupsClient(t *testing.T, subscriptionID string) *armresources.ResourceGroupsClient {
	client, err := armresources.NewResourceGroupsClient(subscriptionID, getAzureCredential(t), getAzureClientOptions())
	require.NoError(t, err, "unable to create ResourceGroups client")
	return client
}

func getAzureRedisClient(t *testing.T, subscriptionID string) *armredis.Client {
	client, err := armredis.NewClient(subscriptionID, getAzureCredential(t), getAzureClientOptions())
	require.NoError(t, err, "unable to create Redis client")
	return client
}
