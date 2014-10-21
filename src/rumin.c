#include <ncurses.h>
#include <locale.h>
#include <stdlib.h>
#define BUFFSIZE 100

#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"

void redisplay(mrb_state *mrb, mrb_value buffer);
void evaluate(mrb_state *mrb, mrb_value command, mrb_value key, mrb_value buffer);

int main() {
    char buf[BUFFSIZE];
    int key;

    //日本語
    setlocale(LC_ALL,"");
    // curses初期化
    initscr();
    cbreak();
    noecho();

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

    while(1) {
        key = getch();
        mrb_value input_key = mrb_fixnum_value(key);
        evaluate(mrb, command_instance, input_key, buffer_instance);
        redisplay(mrb, buffer_instance);
    }

    endwin();

    mrb_close(mrb);

    return 0;
}

void redisplay(mrb_state *mrb, mrb_value buffer){
    clear();
    mrb_value buffer_output = mrb_funcall(mrb, buffer, "get_content", 0);
    const char *body = mrb_string_value_ptr(mrb, buffer_output);
    addstr(body);
}

void evaluate(mrb_state *mrb, mrb_value command, mrb_value key, mrb_value buffer){
    mrb_funcall(mrb, command, "evaluate", 2, key, buffer);
}
