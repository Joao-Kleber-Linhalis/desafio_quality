import 'package:desafio_quarkus/constants.dart';
import 'package:flutter/material.dart';

class FormFieldComponent extends StatelessWidget {
  final String textoLabel;
  final String textoDica;
  final bool passaword;
  final TextStyle? style;
  final TextEditingController? controlador;
  late FormFieldValidator<String>? validador;
  final TextInputType teclado;
  final FocusNode? marcadorFoco;
  final FocusNode? recebedorFoco;

  //função de fazer o onSubmitted
  final Function? onSubmitted;

  final Function? onSaved;

  FormFieldComponent(
    this.textoLabel, {
    super.key,
    this.textoDica = "",
    this.passaword = false,
    this.controlador,
    this.validador,
    this.teclado = TextInputType.text,
    this.marcadorFoco,
    this.recebedorFoco,
    this.onSubmitted,
    this.onSaved,
    this.style,
  }) {
    validador ??= (String? text) {
      if (text!.isEmpty) {
        return "O campo '$textoLabel' está vazio e necessita ser preenchido";
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (text) {
        if (onSaved != null) {
          onSaved;
        }
      },
      validator: validador,
      obscureText: passaword,
      controller: controlador,
      keyboardType: teclado,
      textInputAction: TextInputAction.next,
      focusNode: marcadorFoco,
      onFieldSubmitted: (String text) {
        //Se não tiver proximo foco(Campo), vai executar a função que chegou pra ele, se existir
        if (recebedorFoco != null) {
          FocusScope.of(context).requestFocus(recebedorFoco);
        } else {
          onSubmitted;
        }
      },
      // Estilo da fonte
      style: style ??
          const TextStyle(
            fontSize: 25,
            color: Pallete.black,
          ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: textoLabel,
        // Estilo de labelText
        labelStyle: style ??
            const TextStyle(
              fontSize: 25,
              color: Pallete.black,
            ),
        hintText: textoDica,
        // Estilo do hintText
        hintStyle: style ?? const TextStyle(
              fontSize: 15,
              color: Pallete.black,
            ),
      ),
    );
  }
}
