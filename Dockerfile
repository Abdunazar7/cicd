FROM node:alpine AS builder
WORKDIR /app

# Faqat package.jsonlarni kiritamiz (cache uchun yaxshi)
COPY package*.json ./

# Dev dependency’lar bilan o‘rnatamiz (build uchun kerak)
RUN npm ci

# Keyin qolgan project fayllarini ko‘chiramiz
COPY . .

# Nest build
RUN npm run build --prod

# --- Production image ---
FROM node:alpine
WORKDIR /app

# Stack’da deps qayta o‘rnatish uchun faqat package.jsonlarni ko‘chiramiz
COPY package*.json ./

# Faqat prod dependency’lar
RUN npm ci --omit=dev

# Build qilingan dist'ni builderdan olamiz
COPY --from=builder /app/dist ./dist

# Appni ishga tushiramiz
CMD ["node", "dist/main.js"]
