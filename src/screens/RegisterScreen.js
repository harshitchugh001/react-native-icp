import React, { useState } from 'react';
import {
  SafeAreaView,
  ScrollView,
  View,
  Text,
  TouchableOpacity,
} from 'react-native';

import { Login } from "../declarations/login";

import InputField from '../components/InputField';
import CustomButton from '../components/CustomButton';

const RegisterScreen = ({ navigation }) => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const register = async () => {
    try {
      // console.log({ name, email, password, confirmPassword });
      // Add registration logic here
      const userInfo={
        userName:"rahul",
        userEmail:"rahul@gmail.com",
        userPassword:"hhhhhh",
        userConfirmPassword:"hhhhhh",
      }

      console.log(userInfo);
      // console.log(Login);
      const registeruser =await Login.getPK();
      console.log(registeruser);
      
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <SafeAreaView style={{ flex: 1, justifyContent: 'center' }}>
      <ScrollView
        showsVerticalScrollIndicator={false}
        style={{
          paddingHorizontal: 25,
          paddingVertical: 30
        }}>
        <Text
          style={{
            fontFamily: 'Roboto-Medium',
            fontSize: 28,
            fontWeight: '500',
            color: '#333',
            marginBottom: 30,
          }}>
          Register
        </Text>

        <InputField
          label={'Full Name'}
          placeholder={"Enter your name here"}
          onChangeText={setName}
        />

        <InputField
          label={'Email ID'}
          keyboardType="email-address"
          onChangeText={setEmail}
        />

        <InputField
          label={'Password'}
          secureTextEntry={true}
          onChangeText={setPassword}
        />

        <InputField
          label={'Confirm Password'}
          secureTextEntry={true}
          onChangeText={setConfirmPassword}
        />
        
        <CustomButton label={'Register'} onPress={register} />

        <View
          style={{
            flexDirection: 'row',
            justifyContent: 'center',
            marginBottom: 30,
          }}>
          <Text>Already registered?</Text>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Text style={{ color: '#AD40AF', fontWeight: '700' }}> Login</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default RegisterScreen;
