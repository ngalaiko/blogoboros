DOCKER ?= $(shell command -v docker 2>/dev/null || command -v podman 2>/dev/null)
IMAGE  ?= blogoboros

BLOGS := jekyll hugo gatsby nextjs astro eleventy zola

.PHONY: all serve walk clean $(BLOGS) wordpress

all:
	$(DOCKER) build -t $(IMAGE) .

# Build/cache a single blog's stage.
$(BLOGS): %:
	$(DOCKER) build --target build-$* -t $(IMAGE)-$* .

wordpress:
	$(DOCKER) build --target wordpress-dist -t $(IMAGE)-wordpress .

# Full stack on :8080 — seven static eras and one real WordPress.
serve: all
	$(DOCKER) run --rm -p 8080:8080 $(IMAGE)

# Build, boot, follow the banners around the ring, assert closure.
walk: all
	DOCKER=$(DOCKER) ./scripts/walk-the-circle.sh $(IMAGE)

clean:
	$(DOCKER) rmi -f $(IMAGE) $(foreach b,$(BLOGS),$(IMAGE)-$(b)) $(IMAGE)-wordpress 2>/dev/null || true
