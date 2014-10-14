#include <ncurses.h>
#define BUFFSIZE 100

#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"

int main() {
    char buf[BUFFSIZE];
    int input;

    // curses初期化
    initscr();
    cbreak();

    // キーボード入力受け付け
    getstr(buf);

    mrb_state *mrb = mrb_open();
    // mrubyファイルをロードする
    FILE *f = fopen("caller.rb", "r");
    mrb_load_file(mrb, f);

    // クラスオブジェクトを取得する
    struct RClass *caller = mrb_class_get(mrb, "Caller");

    // 引数をmrb_valueに変換する
    mrb_value caller_value = mrb_obj_value(caller);
    mrb_value body_input = mrb_str_new(mrb, buf, strlen(buf));

    // Caller#newを呼び出す
    mrb_value call = mrb_funcall(mrb, caller_value, "new", 0);

    // 入力値の格納（アクセサメソッドを実行）
    mrb_funcall(mrb, call, "body=", 1, body_input);
    // 入力値の取得（アクセサメソッドを実行）
    mrb_value body_output = mrb_funcall(mrb, call, "body", 0);
    const char *body = mrb_string_value_ptr(mrb, body_output);
    addstr(body);
    // 画面を表示するために入力待ちにする
    //input = getch();
    endwin();

    mrb_close(mrb);

    return 0;
}
