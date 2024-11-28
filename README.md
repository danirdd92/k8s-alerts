Overview
The Grafana Helm chart allows you to:

Configure Grafana via values.yaml.
Provision dashboards, datasources, and alerts using sidecar containers that watch for ConfigMaps and Secrets.
Configure SMTP settings directly in the Helm chart.
We will:

Prepare the alerting configurations as Kubernetes ConfigMaps.
Configure the Helm chart to load these configurations via sidecars.
Set up SMTP settings within the Helm chart's values.
Deploy Grafana using the Helm chart with the customized configurations.
1. Prepare Alerting Configurations as ConfigMaps
We need to create Kubernetes ConfigMaps for:

Alerting rules
Contact points
Notification policies
Notification templates
1.1. Alerting Rules ConfigMap
Create a ConfigMap containing the alerting rules.

File: kubernetes-alert-rules.yaml

yaml
Copy code
apiVersion: v1
kind: ConfigMap
metadata:
  name: kubernetes-alert-rules
  labels:
    grafana_alert: "1"
data:
  kubernetes_alert_rules.yaml: |-
    apiVersion: 1
    groups:
      - name: KubernetesPodAlerts
        interval: 1m
        rules:
          # Alert for Pods Not Starting for Over 10 Minutes
          - alert: PodsNotStartingOver10Min
            expr: |
              count by (cluster, namespace, pod) (
                ((time() - kube_pod_created{job="kube-state-metrics"}) > 600)
                and on(namespace, pod) kube_pod_status_phase{phase=~"Pending|Unknown", job="kube-state-metrics"}
              ) > 0
            for: 0m
            labels:
              severity: warning
            annotations:
              summary: 'Pod {{ $labels.pod }} has not started for over 10 minutes.'
              description: 'Pod {{ $labels.pod }} in namespace {{ $labels.namespace }} on cluster {{ $labels.cluster }} has been in a non-running state for over 10 minutes.'

          # ... (Include other alert rules as needed)
Explanation:

metadata.labels.grafana_alert: "1": This label is used by the sidecar to pick up the ConfigMap.
data: Contains the alert rules file.
1.2. Contact Points ConfigMap
File: grafana-contact-points.yaml

yaml
Copy code
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-contact-points
  labels:
    grafana_alert_notification: "1"
data:
  contact_points.yaml: |-
    notifiers:
      - name: EmailContactPoint
        type: email
        uid: email_contact_point
        settings:
          addresses: 'your-email@example.com'
1.3. Notification Policies ConfigMap
File: grafana-notification-policies.yaml

yaml
Copy code
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-notification-policies
  labels:
    grafana_alert_notification: "1"
data:
  notification_policies.yaml: |-
    alerting:
      notification_policies:
        - receiver: EmailContactPoint
          # Optionally add matchers
1.4. Notification Templates ConfigMap
File: grafana-notification-templates.yaml

yaml
Copy code
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-notification-templates
  labels:
    grafana_alert_notification: "1"
data:
  notification_templates.yaml: |-
    templates:
      - name: default_template
        type: email
        definition: |
          {{ define "default.email.subject" }}
            [{{ .Status | toUpper }}] {{ .AlertName }}: {{ .CommonAnnotations.summary }}
          {{ end }}

          {{ define "default.email.body" }}
            <h1>{{ .Status | toUpper }}: {{ .AlertName }}</h1>
            <p>{{ .CommonAnnotations.description }}</p>
            <p><b>Labels:</b></p>
            <ul>
            {{ range $k, $v := .GroupLabels }}
              <li>{{ $k }}: {{ $v }}</li>
            {{ end }}
            </ul>
          {{ end }}
2. Configure the Grafana Helm Chart
We'll update the values.yaml of the Grafana Helm chart to:

Enable sidecar containers to pick up the ConfigMaps.
Set up SMTP settings for email notifications.
2.1. Enable Sidecars in values.yaml
The Grafana Helm chart supports sidecars for provisioning:

Dashboards
Datasources
Alerting configurations (since Grafana 8)
We will use the sidecar for alerting configurations.

Add the following to values.yaml:

yaml
Copy code
# values.yaml

grafana.ini:
  # SMTP configuration for email notifications
  smtp:
    enabled: true
    host: smtp.example.com:587
    user: your-smtp-username
    password: your-smtp-password
    from_address: grafana@example.com
    from_name: Grafana

# Enable the sidecar for alerting configurations
sidecar:
  alerting:
    enabled: true
    label: grafana_alert
    searchNamespace: ALL

  notifications:
    enabled: true
    label: grafana_alert_notification
    searchNamespace: ALL

  # If you plan to use dashboards and datasources sidecars
  dashboards:
    enabled: false
  datasources:
    enabled: false
Explanation:

grafana.ini.smtp: Configure SMTP settings directly in the Helm chart.
sidecar.alerting: Enables the sidecar to pick up ConfigMaps with the label grafana_alert for alert rules.
sidecar.notifications: Enables the sidecar to pick up ConfigMaps with the label grafana_alert_notification for contact points, notification policies, and templates.
searchNamespace: ALL: The sidecars will look for ConfigMaps in all namespaces.
2.2. Set Up the SMTP Credentials Securely
It's important to secure sensitive information like SMTP credentials.

Option 1: Use Kubernetes Secrets

Create a Kubernetes Secret for SMTP credentials.

File: grafana-smtp-secret.yaml

yaml
Copy code
apiVersion: v1
kind: Secret
metadata:
  name: grafana-smtp-secret
type: Opaque
stringData:
  smtp_user: your-smtp-username
  smtp_password: your-smtp-password
Update values.yaml to use the Secret:

yaml
Copy code
grafana.ini:
  smtp:
    enabled: true
    host: smtp.example.com:587
    user: $__smtp_user
    password: $__smtp_password
    from_address: grafana@example.com
    from_name: Grafana

env:
  # Reference the SMTP credentials from the Secret
  - name: __smtp_user
    valueFrom:
      secretKeyRef:
        name: grafana-smtp-secret
        key: smtp_user
  - name: __smtp_password
    valueFrom:
      secretKeyRef:
        name: grafana-smtp-secret
        key: smtp_password
Option 2: Use Helm Secrets

Alternatively, you can use Helm to pass sensitive values during deployment.

3. Deploy ConfigMaps and Helm Chart
3.1. Apply the ConfigMaps
Deploy the ConfigMaps to your Kubernetes cluster.

bash
Copy code
kubectl apply -f kubernetes-alert-rules.yaml
kubectl apply -f grafana-contact-points.yaml
kubectl apply -f grafana-notification-policies.yaml
kubectl apply -f grafana-notification-templates.yaml
kubectl apply -f grafana-smtp-secret.yaml  # If using the secret
3.2. Install or Upgrade Grafana via Helm
If you haven't installed Grafana yet:

bash
Copy code
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana -f values.yaml
If you're upgrading an existing Grafana release:

bash
Copy code
helm upgrade grafana grafana/grafana -f values.yaml
4. Verify the Deployment
4.1. Check Grafana Pods
Ensure that the Grafana pod is running and that sidecars are present.

bash
Copy code
kubectl get pods
You should see the Grafana pod with additional sidecar containers.

4.2. Check Sidecar Logs
Verify that the sidecars have picked up the ConfigMaps.

bash
Copy code
kubectl logs <grafana-pod-name> -c grafana-sc-alerts
kubectl logs <grafana-pod-name> -c grafana-sc-notifications
Note: The sidecar containers are named grafana-sc-alerts and grafana-sc-notifications.

4.3. Access Grafana
Retrieve the admin password:

bash
Copy code
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
Port-forward the Grafana service to access the UI:

bash
Copy code
kubectl port-forward service/grafana 3000:80
Navigate to http://localhost:3000 and log in.

5. Verify Alerting Configuration in Grafana
5.1. Alert Rules
Navigate to Alerting > Alert Rules.
Verify that your alert rules are listed.
5.2. Contact Points
Navigate to Alerting > Contact Points.
Ensure that EmailContactPoint is configured with the correct email address.
5.3. Notification Policies
Navigate to Alerting > Notification Policies.
Verify that the policy is routing alerts to EmailContactPoint.
5.4. Notification Templates
Check that the custom notification template is in use.
6. Test Email Notifications
Trigger a test alert to ensure that emails are sent correctly.

6.1. Create a Test Alert Rule
You can create a temporary alert rule that will fire immediately.

yaml
Copy code
- alert: TestAlert
  expr: vector(1)
  for: 0m
  labels:
    severity: critical
  annotations:
    summary: 'This is a test alert'
    description: 'Testing email notifications from Grafana'
Add this rule to the kubernetes_alert_rules.yaml ConfigMap and apply it.

6.2. Verify Email Receipt
Wait for the alert to fire.
Check your email inbox for the alert notification.
7. Additional Notes
7.1. Configuring Matchers in Notification Policies
You can refine which alerts go to which contact points by adding matchers.

Example:

yaml
Copy code
alerting:
  notification_policies:
    - receiver: CriticalAlertsEmail
      matchers:
        - severity = critical
    - receiver: WarningAlertsEmail
      matchers:
        - severity = warning
7.2. Multiple Email Addresses
To send notifications to multiple email addresses, separate them with commas.

yaml
Copy code
settings:
  addresses: 'email1@example.com,email2@example.com'
7.3. Using Secrets for Email Addresses
If you prefer not to hardcode email addresses in ConfigMaps, you can use Kubernetes Secrets and reference them using environment variables.

7.4. Grafana Version Compatibility
Ensure that the Grafana Helm chart version you are using supports the unified alerting features and sidecars for alerting configurations.

Grafana 8.0+: Unified alerting is available.
Helm Chart Version: Use the latest stable version.
7.5. Sidecar Configuration Options
The sidecars can be configured further in the Helm chart:

yaml
Copy code
sidecar:
  alerting:
    enabled: true
    label: grafana_alert
    folder: /etc/grafana/provisioning/alerting
    reloadURL: http://localhost:3000/-/reload
    watchMethod: polling  # or 'WATCH'
    pollingIntervalSeconds: 10
Adjust these settings based on your requirements.

8. Complete values.yaml Example
Here's a complete example of the values.yaml file incorporating all the configurations.

yaml
Copy code
# values.yaml

# SMTP settings
grafana.ini:
  smtp:
    enabled: true
    host: smtp.example.com:587
    user: $__smtp_user
    password: $__smtp_password
    from_address: grafana@example.com
    from_name: Grafana

# Environment variables for SMTP credentials
env:
  - name: __smtp_user
    valueFrom:
      secretKeyRef:
        name: grafana-smtp-secret
        key: smtp_user
  - name: __smtp_password
    valueFrom:
      secretKeyRef:
        name: grafana-smtp-secret
        key: smtp_password

# Sidecar configurations
sidecar:
  alerting:
    enabled: true
    label: grafana_alert
    searchNamespace: ALL

  notifications:
    enabled: true
    label: grafana_alert_notification
    searchNamespace: ALL

# Admin password (optional)
adminPassword: 'admin'

# Service configuration
service:
  type: ClusterIP
  port: 80
9. Conclusion
By integrating the alerting configurations with the Grafana Helm chart, you've:

Automated the deployment of Grafana with your custom alerting rules.
Centralized configuration management using Kubernetes ConfigMaps.
Ensured scalability for multi-cluster environments.
Secured sensitive information using Kubernetes Secrets.
This approach leverages the powerful features of Kubernetes and Helm to manage Grafana configurations efficiently.

10. References
Grafana Helm Chart Documentation: https://github.com/grafana/helm-charts/tree/main/charts/grafana
Grafana Sidecar Configuration: https://github.com/grafana/helm-charts/tree/main/charts/grafana#sidecar-for-dashboards
Kubernetes ConfigMaps: https://kubernetes.io/docs/concepts/configuration/configmap/
Kubernetes Secrets: https://kubernetes.io/docs/concepts/configuration/secret/
SMTP Configuration in Grafana: https://grafana.com/docs/grafana/latest/setup-grafana/configure-smtp/
