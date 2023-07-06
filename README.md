# Как собрать контейнер?

Собираю контейнер
```
docker build . -t maniaque/finenomore:1.0
```

И кладу его в Docker Hub
```
docker push maniaque/finenomore:1.0
```

# Как запустить на своей машине?

```
docker-compose up
```

# Как редактировать код?

Поскольку код у нас копируется в контейнер на этапе сборки, то редактировать код онлайн просто так не получится.

Чтобы сделать возможным простое редактирование, нам нужно переименовать файл `docker-compose.override.yml-` (да, именно так, с минусом) в файл `docker-compose.override.yml` (без минуса).

После этого можно выполнять команду docker-compose up, и директория app будет прокидываться внутрь контейнера, оставаясь отлично редактируемой в файловой системе.

# Как запустить в кластере?

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
~~~bash
yc iam key create \
  --service-account-id ajenudqiv3rbtcnqf3bh \
  --folder-id b1g0muq63s1j2m4h5oab \
  --output ~/.yc_keys/key.json
~~~


~~~bash
yc resource-manager folder add-access-binding b1g0muq63s1j2m4h5oab \
  --role admin \
  --subject serviceAccount:ajenudqiv3rbtcnqf3bh 
~~~

  cloud_id  = "b1g85rkpqt0ukuce35r3"
  folder_id = "b1g0muq63s1j2m4h5oab"

> https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider


yc config set service-account-key ~/.yc_keys/key.json
yc config set cloud-id "b1g85rkpqt0ukuce35r3"
yc config set folder-id "b1g0muq63s1j2m4h5oab" 


~~~bash
yc compute instance start yc-toolbox
yc managed-kubernetes cluster start k8s-master
~~~

~~~bash
yc compute instance stop yc-toolbox
yc managed-kubernetes cluster stop k8s-master
~~~

~~~bash
yc load-balancer network-load-balancer list 
~~~
~~~console
+----------------------+----------------------------------------------+-------------+----------+----------------+------------------------+--------+
|          ID          |                     NAME                     |  REGION ID  |   TYPE   | LISTENER COUNT | ATTACHED TARGET GROUPS | STATUS |
+----------------------+----------------------------------------------+-------------+----------+----------------+------------------------+--------+
| enp441clrius9r60pjth | k8s-4e99be9d1a75bbe6a01c8bb67b1e5031153f8b76 | ru-central1 | EXTERNAL |              2 | enpkpddldcg79vqrfbam   | ACTIVE |
+----------------------+----------------------------------------------+-------------+----------+----------------+------------------------+--------+
~~~

~~~bash
yc load-balancer network-load-balancer get enp441clrius9r60pjth | grep address 
~~~

~~~console
address: 51.250.87.33
address: 51.250.87.33
~~~

~~~bash
kubectl create namespace finenomore
~~~

~~~bash
kubectl create secret docker-registry gitlab-credentials --docker-server=stumpd.gitlab.yandexcloud.net:5050 --docker-username="gitlab+deploy-token-1" --docker-password="PASSWORD" --docker-email=dmitriypnev@gmail.com -n finenomore 
~~~
