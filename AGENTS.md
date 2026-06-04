# AGENTS.md

このリポジトリで作業するエージェント向けの追加指示です。

## Git / GitHub 操作

- Git 操作は基本的に `but` (GitButler CLI) を使用してください。
- `but status -fv` が `Not currently on a gitbutler/* branch` で失敗した場合は、`git` に切り替えず、まず `but setup --help` と `but branch new --help` を確認してください。
- 既存の Git リポジトリで GitButler を使い始める場合は、`but setup` で GitButler project として設定し、`gitbutler/workspace` に入ってから `but status -fv` を再実行してください。
- 新しい作業は必要に応じて `but branch new <branch-name>` で branch を作成してから進めてください。
- GitHub の URL に直接アクセスしないでください。GitHub 操作や確認は `gh` CLI を使用してください。
- fork 元や upstream リポジトリの tree に対して変更を加えないでください。
- push する前に、対象が正しい organization / repository であることを毎回コメントして確認してください。
- GitHub API で更新系の操作をする場合は `PUT` を使用してください。

## Pull Request / Merge

- Pull Request を作成してください。
- ユーザーのリポジトリに対して Pull Request をマージして問題ありません。

## Commit

- commit するときは Conventional Commits に従ってください。
- commit message と commit description は英語で書いてください。
- commit description には Why と What がわかるように丁寧に記載してください。
