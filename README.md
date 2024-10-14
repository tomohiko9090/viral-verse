# KuchikomiElevator

## ユーザー権限と機能アクセス

| ユーザー権限 | アクセス範囲 | ShopsController | ReviewsController |
|-------------|------------|-----------------|-------------------|
| admin       | すべてのお店 | すべて            | すべて              |
| owner       | 特定のお店   | show, edit, update | すべて              |
| customer    | 特定のお店   | アクセス不可           | new, create, notice |