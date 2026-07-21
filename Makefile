.PHONY: up down logs test-backend check

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker compose logs -f --tail=150

test-backend:
	pytest -q backend/tests

check:
	python -m compileall -q backend
