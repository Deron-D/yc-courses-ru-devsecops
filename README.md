# Материалы для курса «DevSecOps в облачном CI/CD»

https://practicum.yandex.ru/profile/ycloud-devsecops/subscribe

* [Как собрать контейнер?](#build)
* [Как запустить на своей машине?](#runlocal)
* [Как редактировать код?](#edit)
* [Как запустить в кластере?](#runcluster)

## Как собрать контейнер? <a id="build"/></a>

Собираю контейнер
```
docker build . -t maniaque/finenomore:1.0
```

И кладу его в Docker Hub
```
docker push maniaque/finenomore:1.0
```

## Как запустить на своей машине? <a id="runlocal"/></a>

```
docker-compose up
```

## Как редактировать код? <a id="edit"/></a>

Поскольку код у нас копируется в контейнер на этапе сборки, то редактировать код онлайн просто так не получится.

Чтобы сделать возможным простое редактирование, нам нужно переименовать файл `docker-compose.override.yml-` (да, именно так, с минусом) в файл `docker-compose.override.yml` (без минуса).

После этого можно выполнять команду docker-compose up, и директория app будет прокидываться внутрь контейнера, оставаясь отлично редактируемой в файловой системе.

## Как запустить в кластере? <a id="runcluster"/></a>

Перед запуском нужно выполнить ряд проверочных шагов:

1. Контейнер с приложением должен быть собран и размещен где-то, откуда его сможет забрать кластер. В большинстве случаев это Docker Hub.

2. Нужно убедиться, что у сервисного аккаунта кластера есть роль load-balancer.admin -- эта роль не добавляется, если сервисный аккаунт для кластера создается автоматически

3. Еще перед установкой нужно определиться с тем, каким образом мы будем доставлять трафик к приложению. В этом примере мы возьмем Ingress-контроллер NGINX, его установка описана в [документации](https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/ingress-cert-manager)

Дальше после получения необходимого файла конфигурации для доступа к кластеру, выполняем следующие команды для установки Ingress-контроллера NGINX:

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx
```

Для установки приложения в кластер можно использовать Helm Chart, который находится в директории `k8s/finenomore`

Переходим в эту директорию

```
cd k8s/finenomore
```

Устанавливаем чарт

```
helm install finenomore .
```

---
```
kubectl create secret docker-registry gitlab-credentials --docker-server=dpnev.gitlab.yandexcloud.net:5050 --docker-username=dmitriypnev --docker-password=glpat-_qxMEjwoZaXUUKPBhxS- --docker-email=dmitriypnev@gmail.com -n finenomore
```
```
helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install finenomore-gitlab-agent gitlab/gitlab-agent \
    --namespace gitlab-agent-finenomore-gitlab-agent \
    --create-namespace \
    --set image.tag=v16.6.0 \
    --set config.token=glagent-Mfqm8PUQD_KXNYoxDfLD3LXtHsGj9s6s8RFoumBFgz3H5fDcpg \
    --set config.kasAddress=wss://dpnev.gitlab.yandexcloud.net/-/kubernetes-agent/
```


