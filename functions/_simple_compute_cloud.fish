function _simple_compute_cloud
    # AWS — show profile if set
    set -l aws_profile
    set -q AWS_PROFILE;         and set aws_profile $AWS_PROFILE
    set -q AWS_VAULT;           and set aws_profile $AWS_VAULT
    if test -z "$aws_profile"; and set -q AWS_DEFAULT_PROFILE
        set aws_profile $AWS_DEFAULT_PROFILE
    end
    if test -n "$aws_profile"
        echo "CLOUD_AWS=$aws_profile"
    end

    # gcloud — only if explicitly active config or gcloud files around
    if command -q gcloud
        if set -q CLOUDSDK_ACTIVE_CONFIG_NAME
            echo "CLOUD_GCLOUD=$CLOUDSDK_ACTIVE_CONFIG_NAME"
        else if _simple_has_up app.yaml; or _simple_has_up cloudbuild.yaml
            set -l cfg (command gcloud config configurations list --format='value(name)' --filter='is_active=True' 2>/dev/null | string trim)
            test -n "$cfg"; and echo "CLOUD_GCLOUD=$cfg"
        end
    end

    # kubectl — only when k8s-related files are present (avoids spawning kubectl everywhere)
    if command -q kubectl
        set -l found_k8s 0
        for k in kustomization.yaml kustomization.yml Chart.yaml helmfile.yaml k8s kubernetes
            if _simple_has_up $k
                set found_k8s 1
                break
            end
        end
        if test $found_k8s -eq 1
            set -l ctx (command kubectl config current-context 2>/dev/null | string trim)
            test -n "$ctx"; and echo "CLOUD_K8S=$ctx"
        end
    end

    # terraform
    if _simple_has_up main.tf; or _simple_has_up .terraform; or _simple_has_up terragrunt.hcl
        if command -q terraform
            set -l ws (command terraform workspace show 2>/dev/null | string trim)
            test -n "$ws"; and echo "CLOUD_TF=$ws"
        end
    end

    # docker
    if _simple_has_up Dockerfile; or _simple_has_up docker-compose.yml; or _simple_has_up docker-compose.yaml; or _simple_has_up compose.yml; or _simple_has_up compose.yaml
        if set -q DOCKER_CONTEXT
            echo "CLOUD_DOCKER=$DOCKER_CONTEXT"
        else if set -q DOCKER_HOST
            echo "CLOUD_DOCKER=$DOCKER_HOST"
        end
    end
end
