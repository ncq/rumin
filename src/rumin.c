#include <ncurses.h>
#include <locale.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#define BUFFSIZE 100

#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"
#include "mruby/array.h"

void input_key(mrb_state *mrb, mrb_value keys);

int main() {
    char buf[BUFFSIZE];
    int h,w;
    //日本語
    setlocale(LC_ALL,"");

    mrb_state *mrb = mrb_open();

    // Ruminインスタンスの作成
    // mrubyファイルのロード
    FILE *f1 = fopen("mruby/rumin.rb", "r");
    // mrb_load_irep_file(mrb, f1);
    mrb_load_file(mrb, f1);
    // クラスオブジェクトを取得する
    struct RClass *rumin = mrb_class_get(mrb, "Rumin");
    // 引数をmrb_valueに変換する
    mrb_value rumin_value = mrb_obj_value(rumin);
    // Rumin#newを呼び出す
    mrb_value rumin_instance = mrb_funcall(mrb, rumin_value, "new", 0);
    // Editorインスタンスの取得
    mrb_value editor_instance = mrb_funcall(mrb, rumin_instance, "editor", 0);
    // Bufferインスタンスの取得
    mrb_value buffer_instance = mrb_funcall(mrb, editor_instance, "current_buffer", 0);
    /* Displayインスタンスの取得 */
    mrb_value display_instance = mrb_funcall(mrb, editor_instance, "display", 0);
    mrb_funcall(mrb, buffer_instance, "set_display", 1, display_instance);
    mrb_value window = mrb_funcall(mrb, display_instance, "create_window", 1, buffer_instance);

    // Commandインスタンスの初期化
    FILE *f3 = fopen("mruby/command.rb", "r");
    mrb_load_file(mrb, f3);
    struct RClass *command = mrb_class_get(mrb, "Command");
    mrb_value command_value = mrb_obj_value(command);
    mrb_value command_instance = mrb_funcall(mrb, command_value, "new", 0);

    mrb_value keys = mrb_ary_new(mrb);
    mrb_value ret;
    while(1) {
        input_key(mrb, keys);
        ret = mrb_funcall(mrb, command_instance, "evaluate", 2, keys, buffer_instance);
        // Rumin終了
        if(mrb_fixnum(ret) == 0) { break; }
        mrb_funcall(mrb, display_instance, "redisplay", 0);

    }

    mrb_funcall(mrb, display_instance, "finish", 0);

    mrb_close(mrb);

    return 0;
}

void input_key(mrb_state *mrb, mrb_value keys){
    int key;
    key = getch();
    mrb_ary_clear(mrb, keys);
    mrb_ary_push(mrb, keys, mrb_fixnum_value(key));
    if(key >= 192 && key <= 223) {
        // 2 bytes
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    } else if(key >= 224 && key <= 239) {
        // 3 bytes
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    } else if(key >= 240 && key <= 255) {
        // 4 bytes
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    }
}
