#include <ncurses.h>
#define BUFFSIZE 100

#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"

int main() {

/*    char buf[BUFFSIZE];

    initscr();
    cbreak();    // キー入力を直ちに受け付ける
    getstr(buf);
    addstr(buf);
    endwin();
*/

    mrb_state* mrb = mrb_open();
    // mrubyファイルをロードする
    //FILE *f = fopen("caller.mrb", "r");
    FILE* f = fopen("caller.rb", "r");

    //mrb_load_irep_file(mrb, f);
    mrb_load_file(mrb, f);

    //fclose(f);
printf("check\n");
    // クラスオブジェクトを取得する
    struct RClass* caller = mrb_class_get(mrb, "Caller");
printf("check\n");

    // 引数をmrb_valueに変換する
    mrb_value caller_value = mrb_obj_value(caller);
    mrb_value str1_value = mrb_str_new(mrb, "hoge", 4);
    mrb_value str2_value = mrb_str_new(mrb, "fuga", 4);

    // Caller#newを呼び出す
    mrb_value call = mrb_funcall(mrb, caller_value, "new", 2, str1_value, str2_value);

    // Caller#printを呼び出す
    mrb_funcall(mrb, call, "print", 0);

    mrb_close(mrb);

    return 0;
}
