import models.ai.com.ops.hops.helm.v1alpha1 as helmv1alpha1
import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1

_items = [
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-release"
        spec = {
            compositionPath = "apis/kubernetesdashboards/composition.yaml"
            xrdPath = "apis/kubernetesdashboards/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = helmv1alpha1.KubernetesDashboard {
                metadata.name = "test-dashboard"
                spec.clusterName = "test-cluster"
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "test-dashboard"
                }
            ]
        }
    }

    metav1alpha1.CompositionTest {
        metadata.name = "custom-labels-merged"
        spec = {
            compositionPath = "apis/kubernetesdashboards/composition.yaml"
            xrdPath = "apis/kubernetesdashboards/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = helmv1alpha1.KubernetesDashboard {
                metadata.name = "labeled-dashboard"
                spec = {
                    clusterName = "test-cluster"
                    labels = {team = "platform"}
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "labeled-dashboard"
                        labels = {
                            "hops.ops.com.ai/managed" = "true"
                            "hops.ops.com.ai/kubernetesdashboard" = "labeled-dashboard"
                            team = "platform"
                        }
                    }
                }
            ]
        }
    }

    metav1alpha1.CompositionTest {
        metadata.name = "override-all-values"
        spec = {
            compositionPath = "apis/kubernetesdashboards/composition.yaml"
            xrdPath = "apis/kubernetesdashboards/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = helmv1alpha1.KubernetesDashboard {
                metadata.name = "override-test"
                spec = {
                    clusterName = "my-cluster"
                    overrideAllValues = {fullnameOverride = "custom-dashboard"}
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "override-test"
                    spec.forProvider.values = {fullnameOverride = "custom-dashboard"}
                }
            ]
        }
    }
]

items = _items
