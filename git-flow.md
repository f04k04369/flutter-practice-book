# Git Flow運用テンプレート

## 1. ブランチ戦略（基本）

### 主要ブランチ

- **main**: 本番運用ブランチ（常にデプロイ可能）
- **develop**: 次リリースの統合ブランチ

### 補助ブランチ

- **feature/**\*: 機能開発（起点: `develop` / 終点: `develop`）
- **release/**\*: リリース準備（起点: `develop` / 終点: `main` と `develop`）
- **hotfix/**\*: 本番緊急修正（起点: `main` / 終点: `main` と `develop`）
- **support/**\*: 旧バージョン保守（必要に応じて）

### 命名例

- `feature/ISSUE-123-login-ui`
- `release/1.4.0`
- `hotfix/1.4.1-logging`

---

## 2. コミット規約（Conventional Commits 推奨）

`<type>(<scope>): <subject>`

- **type例**: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `perf`, `build`, `ci`
- **例**: `feat(auth): add refresh token rotation`

---

## 3. Pull Request テンプレート

ファイルパス: `.github/PULL_REQUEST_TEMPLATE.md`

```markdown
## 概要
- 何を・なぜ

## 変更点
- 箇条書きで

## 動作確認
- [ ] 単体テスト
- [ ] E2E / 手動確認

## 影響範囲
- 依存サービス / モジュール

## チェックリスト
- [ ] タイトルは Conventional Commits 準拠
- [ ] 競合なし / self-review 済み
- [ ] 必要なドキュメント更新済み

## 関連
- Close #123
```

---

## 4. Issue テンプレート

### バグ報告

ファイルパス: `.github/ISSUE_TEMPLATE/bug_report.md`

```yaml
---
name: "🐛 Bug report"
about: 不具合の報告
labels: ["bug"]
---

### 事象
-

### 再現手順
1.
2.

### 期待結果
-

### 追加情報 / スクショ
-
```

### 機能要望

ファイルパス: `.github/ISSUE_TEMPLATE/feature_request.md`

```yaml
---
name: "✨ Feature request"
about: 機能追加の提案
labels: ["enhancement"]
---

### 背景 / 課題
-

### やりたいこと
-

### 受け入れ条件(AC)
- [ ] 条件1
- [ ] 条件2

### 代替案
-
```

---

## 5. 変更履歴（CHANGELOG.md 雛形）

```markdown
# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]
### Added
-
### Changed
-
### Fixed
-

## [1.0.0] - 2025-09-19
### Added
- Initial release
```

---

## 6. バージョン管理（VERSION ファイル）

プロジェクトルートに `VERSION` ファイルを配置し、現在のリリース番号のみを記載します。

```
1.0.0
```

---

## 7. リリース手順テンプレート

ファイルパス: `docs/release-checklist.md`

```markdown
# リリースチェックリスト
## 事前
- [ ] `develop` がグリーン（CI パス）
- [ ] 変更点を `CHANGELOG.md` に反映
- [ ] バージョン更新（`VERSION` / package設定）

## 作業
1. `release/<version>` を作成し最終調整
2. `release/<version>` → `main` へ PR（タグ付けはマージ後）
3. `release/<version>` → `develop` へも反映（差分戻し）

## タグ
- [ ] `git tag -a v<version> -m "Release <version>"`
- [ ] `git push origin v<version>`

## リリース後
- [ ] 本番デプロイ
- [ ] リリースノート配信
```

---

## 8. 簡易リリーススクリプト

ファイルパス: `scripts/release.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

VERSION_FILE="VERSION"
VERSION=$(cat "$VERSION_FILE")

if [[ -z "${VERSION}" ]]; then
  echo "VERSION が空です" >&2; exit 1
fi

git fetch origin
git checkout develop
git pull --rebase

BRANCH="release/${VERSION}"
git checkout -b "${BRANCH}"

# ここで必要ならバージョンを書き換える処理を入れる
# 例: jq で package.json の version を更新 など

git add -A
git commit -m "chore(release): prepare ${VERSION}" || true
git push -u origin "${BRANCH}"

echo "次の手順:"
echo "1) PR: ${BRANCH} -> main を作成しレビュー"
echo "2) マージ後: git checkout main && git pull && git tag -a v${VERSION} -m \"Release ${VERSION}\" && git push origin v${VERSION}"
echo "3) ${BRANCH} を develop にもマージ（差分吸収）"
```
**実行権限の付与:**
```bash
chmod +x scripts/release.sh
```

---

## 9. Git hooks（任意）

例: `.git/hooks/commit-msg` （Conventional Commits 検証・簡易版）

```bash
#!/usr/bin/env bash
# 簡易チェック: type(scope): subject
msgfile="$1"
grep -E '^(feat|fix|docs|refactor|test|chore|perf|build|ci)(\(.+\))?: .+' "$msgfile" >/dev/null || {
  echo "コミットメッセージは Conventional Commits に従ってください" >&2
  exit 1
}
```
**実行権限の付与:**
```bash
chmod +x .git/hooks/commit-msg
```

---

## 10. .gitattributes

改行コードの統一やマージ戦略を指定します。

```
* text=auto eol=lf

# Lock 大きめバイナリ
*.psd filter=lfs diff=lfs merge=lfs -text

# 生成物はマージしない
dist/* -merge
```

---

## 11. .gitignore（共通例）

```gitignore
# Node / JS
node_modules/
dist/
coverage/
*.log

# OS
.DS_Store
Thumbs.db

# Env / Secrets
.env
.env.*
```

---

## 12. git-flow 操作チートシート（プレーン Git ベース）

### Featureブランチ
- **開始:**
  ```bash
  git checkout develop
  git pull
  git checkout -b feature/ISSUE-123-xxx
  ```
- **終了:**
  ```bash
  git push -u origin feature/ISSUE-123-xxx
  # Pull Request を作成し develop へマージ
  ```

### Releaseブランチ
- **開始:**
  ```bash
  git checkout develop
  git pull
  git checkout -b release/1.4.0
  ```
- **終了:**
  1. `release/1.4.0` -> `main` へマージ
  2. `main` ブランチで `v1.4.0` のタグを付与
  3. `release/1.4.0` -> `develop` へマージ

### Hotfixブランチ
- **開始:**
  ```bash
  git checkout main
  git pull
  git checkout -b hotfix/1.4.1-foo
  ```
- **終了:**
  1. `hotfix/1.4.1-foo` -> `main` と `develop` へマージ
  2. `main` ブランチで `v1.4.1` のタグを付与

---

## 13. git-flow 運用チュートリアル

このセクションでは、`git-flow` の各ブランチ運用とリモートリポジトリへの反映手順を具体例で解説します。

### 1. 基本の考え方

- **main**: 本番運用（常にデプロイ可能）
- **develop**: 開発統合ブランチ

#### 補助ブランチ
- **feature/**\*: 機能追加
- **release/**\*: リリース準備
- **hotfix/**\*: 緊急修正

👉 基本は「ブランチを切って → 作業して → push → PR（または merge）」の流れです。

### 2. フィーチャーブランチ作成〜リモートアップロード

例: ログイン機能を追加したい場合

1.  **`develop` ブランチに移動して最新化**
    ```bash
    git checkout develop
    git pull origin develop
    ```

2.  **`feature` ブランチを作成**
    ```bash
    git checkout -b feature/login-ui
    ```

3.  **コード修正 → ステージング**
    ```bash
    git add .
    ```

4.  **コミット**
    ```bash
    git commit -m "feat(auth): add login UI"
    ```

5.  **リモートにブランチを作成して push**
    ```bash
    git push -u origin feature/login-ui
    ```
    > 📌 `-u` を付けることで、次回以降は `git push` だけで同じリモートブランチに push できます。

### 3. Pull Request を作成してマージ

1.  GitHub/GitLab などで `feature/login-ui` → `develop` の Pull Request を作成します。
2.  レビューが完了したらマージします。
3.  不要になったローカル/リモートブランチを削除します。
    ```bash
    # develop ブランチに移動して最新化
    git checkout develop
    git pull

    # ローカルブランチを削除
    git branch -d feature/login-ui

    # リモートブランチを削除
    git push origin --delete feature/login-ui
    ```

### 4. リリースブランチの流れ

1.  **`develop` を最新化**
    ```bash
    git checkout develop
    git pull origin develop
    ```
2.  **リリースブランチ作成**
    ```bash
    git checkout -b release/1.0.0
    ```
3.  **バージョン更新や最終テストなど**
    ```bash
    # 例: バージョンファイルを更新
    git add .
    git commit -m "chore(release): bump version to 1.0.0"
    ```
4.  **リモートへ push**
    ```bash
    git push -u origin release/1.0.0
    ```
    その後、`release/1.0.0` → `main` と `release/1.0.0` → `develop` への Pull Request を作成してマージします。

### 5. ホットフィックスの流れ

1.  **`main` からブランチを作成**
    ```bash
    git checkout main
    git pull origin main
    git checkout -b hotfix/1.0.1-logging
    ```
2.  **修正してコミット**
    ```bash
    git add .
    git commit -m "fix(logging): handle null values"
    ```
3.  **リモートへ push**
    ```bash
    git push -u origin hotfix/1.0.1-logging
    ```
    その後、`main` と `develop` の両方へ Pull Request を作成してマージします。

### 6. よく使うコマンド早見表

| 操作 | コマンド例 |
| :--- | :--- |
| ブランチ作成 | `git checkout -b feature/xxx develop` |
| リモートへ push | `git push -u origin feature/xxx` |
| PR 後の削除 | `git branch -d feature/xxx && git push origin --delete feature/xxx` |
| 最新化 | `git pull origin develop` |
| タグ付け | `git tag -a v1.0.0 -m "Release 1.0.0" && git push origin v1.0.0` |

---

## 14. 書籍の写経用ワークフロー

このセクションは、書籍の内容を写経しながら学習を進める際の推奨ワークフローです。

基本的には章ごとに写経を進め、次の章へ進む際に `original` ブランチの状態に戻す、という流れを繰り返します。

### 1. 基本フロー（練習の始め方）

章や節ごとに `original` ブランチから練習用ブランチを作成します。

```bash
# original ブランチに移動して最新の状態にする
git checkout original
git pull

# 練習用ブランチを作成（例: 1章の練習）
git checkout -b feature/ch01-try-001
```

ブランチを作成したら、コードの写経や修正を行い、適宜コミットします。

```bash
git add -A
git commit -m "ch01: Step 1 の実装"
```

練習が終わったブランチは、`git flow feature finish` を使って `develop` にマージしても良いですし、「練習の記録」としてそのまま残しておいても構いません。

### 2. 演習の初期状態に戻す方法

#### A. 現在のブランチで作業内容のみを初期化する（コミット履歴は維持）

> ブランチのコミット履歴は残したまま、ファイルの状態だけを `original` ブランチと同じ状態に戻します。

この方法は、同じ章を何度もやり直して学習したい場合に便利です。

```bash
# コミットしていない変更があれば、一時的に退避（任意）
git stash push -m "WIP before reset"

# 作業ツリーを original ブランチの状態に完全初期化
# （注意: 追跡されていないファイルも強制的に削除されます）
git reset --hard original
git clean -xfd

# サブモジュールがある場合
git submodule foreach --recursive 'git reset --hard && git clean -xfd'
```

**注意:** `git clean -xfd` コマンドは、`.gitignore` で無視されていない限り、追跡対象外のファイル（例: `.env` ファイルやテスト生成物）もすべて削除します。必要なファイルは事前にバックアップするか、`.gitignore` にルールを記述してください。
