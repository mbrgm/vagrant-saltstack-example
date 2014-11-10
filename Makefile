update:
	vagrant ssh master1 -c "sudo salt '*' state.highstate"

genkeys:
	mkdir -p salt/keys; \
	vagrant status \
	| sed -n '/^$$/,/^$$/p' \
	| sed '/^$$/d' \
	| awk '{print $$1;}' \
	| xargs -I % sh -c 'mkdir -p salt/keys/%; \
						openssl genrsa -out salt/keys/%/minion.pem 4096; \
						openssl rsa -pubout -in salt/keys/%/minion.pem -out salt/keys/%/minion.pub'

.PHONY: update
.PHONY: genkeys
