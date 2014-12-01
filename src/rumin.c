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

    getmaxyx(stdscr, h, w);
    WINDOW *echo_win;
    echo_win = subwin(stdscr, 1, 100, h-1, 3);

    mrb_value echo_line = mrb_funcall(mrb, display_instance, "get_echo", 0);
    strncpy(buf, mrb_string_value_ptr(mrb, echo_line), strlen(mrb_string_value_ptr(mrb, echo_line)));
    mvwaddstr(echo_win, 0, 0, buf);
    
    mrb_value keys = mrb_ary_new(mrb);
    while(1) {
        input_key(mrb, keys);
        mrb_funcall(mrb, command_instance, "evaluate", 3, keys, buffer_instance, display_instance);
        mrb_funcall(mrb, display_instance, "redisplay", 0);
        echo_line = mrb_funcall(mrb, display_instance, "get_echo", 0);
        strncpy(buf, mrb_string_value_ptr(mrb, echo_line), strlen(mrb_string_value_ptr(mrb, echo_line)));
        mvwaddstr(echo_win, 0, 0, buf);
        wmove(echo_win, 0, strlen(mrb_string_value_ptr(mrb, echo_line)));
        wclrtobot(echo_win);//clear window behind cursor
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
