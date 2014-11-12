#include <ncurses.h>
#include <locale.h>
#include <stdlib.h>
#include <dlfcn.h>
#define BUFFSIZE 100

#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"
#include "mruby/array.h"

void input_key(mrb_state *mrb, mrb_value keys);

int main() {
    char buf[BUFFSIZE];

    //日本語
    setlocale(LC_ALL,"");

    //TRUEだと特殊生ーを押した時にキーコードを返す。FALSEだとエスケープシーケンス
    //keypad(stdscr, TRUE);

    mrb_state *mrb = mrb_open();

    // Initインスタンスの作成
    // mrubyファイルのロード
    FILE *f1 = fopen("mruby/init.rb", "r");
    // mrb_load_irep_file(mrb, f1);
    mrb_load_file(mrb, f1);
    // クラスオブジェクトを取得する
    struct RClass *init = mrb_class_get(mrb, "Init");
    // 引数をmrb_valueに変換する
    mrb_value init_value = mrb_obj_value(init);
    // Init#newを呼び出す
    mrb_value init_instance = mrb_funcall(mrb, init_value, "new", 0);

    // Bufferインスタンスの初期化
    FILE *f2 = fopen("mruby/buffer.rb", "r");
    mrb_load_file(mrb, f2);
    struct RClass *buffer = mrb_class_get(mrb, "Buffer");
    mrb_value buffer_value = mrb_obj_value(buffer);
    mrb_value buffer_instance = mrb_funcall(mrb, buffer_value, "new", 1, "1");

    // Commandインスタンスの初期化
    FILE *f3 = fopen("mruby/command.rb", "r");
    mrb_load_file(mrb, f3);
    struct RClass *command = mrb_class_get(mrb, "Command");
    mrb_value command_value = mrb_obj_value(command);
    mrb_value command_instance = mrb_funcall(mrb, command_value, "new", 0);

    // Displayインスタンスの初期化
    // コンストラクタでcursesを初期化する
    FILE *f4 = fopen("mruby/display.rb", "r");
    mrb_load_file(mrb, f4);
    struct RClass *display = mrb_class_get(mrb, "Display");
    mrb_value display_value = mrb_obj_value(display);
    mrb_value display_instance = mrb_funcall(mrb, display_value, "new", 0);
    mrb_value window = mrb_funcall(mrb, display_instance, "create_window", 1, buffer_instance);

    mrb_value keys = mrb_ary_new(mrb);
    while(1) {
        input_key(mrb, keys);
        mrb_funcall(mrb, command_instance, "evaluate", 2, keys, buffer_instance);
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
    if(key == 27) {
        // arrow key
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    } else if(key >= 192 && key <= 223) {
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
