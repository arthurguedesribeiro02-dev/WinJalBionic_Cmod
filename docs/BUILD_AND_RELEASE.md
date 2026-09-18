# Build e Release do WinJalBionic Cmod

## Build no GitHub Actions

1. Abra a aba **Actions** do repositório.
2. Selecione **Build and Release APK**.
3. Clique em **Run workflow**.
4. Informe uma tag nova, por exemplo `v0.1.0`.
5. Marque `prerelease` enquanto o APK estiver em testes.
6. Inicie o workflow.

O workflow usa Java 17, Android SDK 35, Build Tools 35.0.0, NDK 27.2.12479018 e CMake 3.22.1. Ele compila `assembleRelease`, calcula SHA-256 e anexa todos os APKs gerados à Release.

O primeiro build pode falhar se algum submodule ou asset de build depender de um repositório externo que não esteja disponível no runner. Nesse caso, leia o log da etapa que falhou; não anexe APK parcial.

## Build local e Release via CLI

```bash
chmod +x gradlew scripts/create-release.sh
./gradlew --no-daemon assembleRelease
./scripts/create-release.sh v0.1.0
```

O script recusa reutilizar uma tag existente, copia os APKs para `release-assets/` e publica também `SHA256SUMS.txt`. Ele requer `gh auth status` autenticado e permissão de escrita no repositório.

## Segurança e licenças

O workflow compila o código do fork. Não inclui arquivos de jogos, APKs baixados de terceiros, executáveis Windows ou assets protegidos. Faça upload somente de APKs produzidos pelo build do fork e componentes cuja redistribuição esteja autorizada. Mantenha os créditos e a licença MIT dos upstreams.

## Comparação prática para GTA V em 4 GB

| Base | Ponto forte | Risco em 4 GB | Perfil inicial |
| --- | --- | --- | --- |
| Ludashi | VulkanRenderer/DisplayX, detecção de GPU e opções de composição | Opções experimentais podem elevar consumo/temperatura | Vulkan estável, 30 FPS, 480–540p interno |
| Cmod | Redução de overhead do controller shim, Box64 atualizado, DXVK/Turnip e VkBasalt por atalho | Mais componentes e combinações aumentam a superfície de compatibilidade | Box64 conservador, DXVK estável, sem filtros |
| Bruno Dev | Base upstream e fluxo de manutenção mais previsível | Pode ter menos ajustes específicos do aparelho | Perfil padrão, 30 FPS, resolução interna reduzida |

Essas diferenças são qualitativas; não representam FPS garantido. Compare no mesmo aparelho, mesma cena, mesma temperatura e mesmo driver. Registre `gfxinfo`, memória, temperatura e logs Vulkan.
