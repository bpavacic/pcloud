{
	v1:: {
	     Namespace(name): {
	     		     apiVersion: 'v1',
	      		     kind: 'Namespace',
	      		     metadata: {
	      		     	       name: name,
	      		     },
	     },

	     Container(name, image): {
	     		  name: name,
			  image: image,
			  imagePullPolicy: 'IfNotPresent',
			  ports: [{
				 containerPort: 1234,
		          },],
			  command: [
              		  	   'rpuppy',
				   '--port=1234',
            	          ],	     
	     },

	     Deployment(name, namespace, containers): {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: name,
    namespace: namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        app: name,
      },
    },
    replicas: 1,
    template: {
      metadata: {
        labels: {
          app: name,
        },
      },
      spec: {
        containers: containers,
      },
    },
  },
	     
	     },
	},
}
